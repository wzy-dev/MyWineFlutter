import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:mywine/recognize.dart';
import 'package:mywine/shelf.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class AddTab extends StatefulWidget {
  const AddTab({Key? key, required this.isActive}) : super(key: key);

  final bool isActive;

  @override
  State<AddTab> createState() => _AddTabState();
}

class _AddTabState extends State<AddTab> with WidgetsBindingObserver {
  bool _cameraIsVisible = false;
  bool? _permissionEnabled;
  bool _cameraReloading = false;
  bool _searchLoading = false;
  Object _cameraKey = Object();
  double _viewportHeight = 0;
  double _viewportWidth = 0;
  double _captureHoleHeight = 0;
  double _captureHoleWidth = 0;
  final PictureController awesomeController = PictureController();
  Directory? cacheDirectory;
  Directory? cacheResizedDirectory;
  AppLifecycleState? _notification;
  bool _isActive = true;
  bool _isInRoot = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
  }

  void _setDirectory() async {
    cacheDirectory = await getTemporaryDirectory();
    cacheResizedDirectory = await Directory('${cacheDirectory!.path}/resized')
        .create(recursive: true);
  }

  @override
  void initState() {
    _setDirectory();
    WidgetsBinding.instance!.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void _onPermissionsResult() async {
    PermissionStatus statusCamera = await Permission.camera.status;
    PermissionStatus statusStorage = await Permission.storage.status;

    if ((statusCamera.isDenied ||
            statusCamera.isPermanentlyDenied ||
            statusStorage.isDenied ||
            statusStorage.isPermanentlyDenied) &&
        _permissionEnabled != false) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.storage,
      ].request();

      statusCamera = statuses[Permission.camera] ?? statusCamera;
      statusStorage = statuses[Permission.storage] ?? statusCamera;

      if (!statusCamera.isDenied &&
          !statusCamera.isPermanentlyDenied &&
          !statusStorage.isDenied &&
          !statusStorage.isPermanentlyDenied) {
        return;
      } else {
        setState(() {
          _permissionEnabled = false;
        });
      }
    } else if ((!statusCamera.isDenied &&
            !statusCamera.isPermanentlyDenied &&
            !statusStorage.isDenied &&
            !statusStorage.isPermanentlyDenied) &&
        _permissionEnabled != true) {
      setState(() {
        _permissionEnabled = true;
      });
    }
  }

  void _toScan() {
    if (cacheDirectory == null) return;

    setState(() {
      _searchLoading = true;
    });

    final String name = DateTime.now().millisecondsSinceEpoch.toString();

    final String filePath = '${cacheDirectory!.path}/$name.jpg';

    awesomeController.takePicture(filePath).then((imageShooted) async {
      final File fileResized = await FlutterImageCompress.compressAndGetFile(
            filePath,
            '${cacheResizedDirectory!.path}/$name.jpg',
            quality: 100,
            minWidth: 700,
            minHeight: 700,
          ) ??
          File(filePath);

      RekognizeProvider.search(base64Encode(fileResized.readAsBytesSync()))
          .then((response) {
        List<vision.AnnotateImageResponse> ocr =
            response.toJson()["responses"] ?? [];

        ocr.forEach((anot) async {
          vision.TextAnnotation? list = anot.fullTextAnnotation;

          if (list != null) {
            ResultSearchVision? resultSearchVision =
                Vision.takePicture(context: context, ocr: list);
            if (resultSearchVision != null) {
              setState(() {
                _isInRoot = false;
              });
              await Navigator.of(context)
                  .pushNamed("/add/wine", arguments: resultSearchVision);
              setState(() {
                _isInRoot = true;
              });
            }
          }
        });
        setState(() {
          _searchLoading = false;
        });
      });
    }).timeout(Duration(seconds: 3), onTimeout: () async {
      setState(() {
        _searchLoading = false;
        _cameraIsVisible = false;
        _cameraReloading = true;
        _cameraKey = Object();
      });
    });
  }

  Widget _drawCamera() {
    if (_notification == AppLifecycleState.inactive ||
        _notification == AppLifecycleState.paused) {
      setState(() {
        _cameraIsVisible = false;
      });
      return Container();
    } else {
      _onPermissionsResult();
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: _permissionEnabled == null
            ? Container()
            : _permissionEnabled == true
                ? AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: _cameraIsVisible ? 1 : 0,
                    child: Stack(
                      children: [
                        CameraAwesome(
                          onCameraStarted: () {
                            setState(() {
                              _cameraIsVisible = true;
                              _cameraReloading = false;
                            });
                          },
                          key: ValueKey(_cameraKey),
                          sensor: ValueNotifier(Sensors.BACK),
                          photoSize: ValueNotifier(Size(0, 0)),
                          captureMode: ValueNotifier(CaptureModes.PHOTO),
                        ),
                        Container(
                          color: _cameraReloading
                              ? Colors.black54
                              : Color.fromRGBO(0, 0, 0, 0),
                        )
                      ],
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/camera_off.svg',
                        width: MediaQuery.of(context).size.width,
                        color: Color.fromRGBO(255, 255, 255, 0.05),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Vous devez donner la permission à MyWine d'accéder à votre caméra pour utiliser le scanner !",
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 0.7)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Appuyez ici pour accéder aux paramétres et donner l'autorisation.",
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 0.7),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive || !_isInRoot) _isActive = false;
    if (widget.isActive && !_isActive && !_cameraIsVisible && _isInRoot)
      _isActive = true;

    if (!_isActive) {
      _cameraIsVisible = false;
      _searchLoading = false;
    }

    _viewportHeight = MediaQuery.of(context).size.height;
    _viewportWidth = MediaQuery.of(context).size.width;

    _captureHoleHeight = (_viewportHeight - 190) * 0.65;
    _captureHoleWidth = _captureHoleHeight * 0.85 < _viewportWidth * 0.7
        ? _captureHoleHeight * 0.85
        : _viewportWidth * 0.7;

    return MainContainer(
      hideAppBar: true,
      child: SafeArea(
        top: false,
        child: _isActive
            ? Container(
                height: _viewportHeight - 190,
                width: _viewportWidth,
                child: InkWell(
                  onTap: _permissionEnabled == true
                      ? null
                      : () => openAppSettings(),
                  child: Stack(
                    children: [
                      Container(
                        child: _drawCamera(),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(22, 8, 10, 1),
                              Color.fromRGBO(22, 8, 10, 0.75),
                            ],
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        curve: Curves.bounceInOut,
                        opacity: _searchLoading
                            ? 1
                            : _cameraIsVisible
                                ? 0.4
                                : 0,
                        duration:
                            Duration(milliseconds: _searchLoading ? 200 : 1000),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Color.fromRGBO(0, 0, 0, 0.8),
                            BlendMode.srcOut,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  backgroundBlendMode: BlendMode.dstOut,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: AnimatedContainer(
                                  // margin: const EdgeInsets.only(bottom: 50),
                                  curve: Curves.easeOutQuart,
                                  duration: Duration(milliseconds: 500),
                                  height: _searchLoading == false
                                      ? _captureHoleHeight - 30
                                      : 0,
                                  width: _searchLoading == false
                                      ? _captureHoleWidth - 30
                                      : 0,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(
                                        _searchLoading == false ? 20 : 100),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        curve: Curves.ease,
                        opacity: _cameraIsVisible ? 1 : 0,
                        duration: Duration(milliseconds: 2000),
                        child: Center(
                          child: Container(
                            // margin: const EdgeInsets.only(bottom: 50),
                            height: _captureHoleHeight,
                            width: _captureHoleWidth,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: RotatedBox(
                                    quarterTurns: 0,
                                    child: Corner(loading: _searchLoading),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: Corner(loading: _searchLoading),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Corner(loading: _searchLoading),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child: Corner(loading: _searchLoading),
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 200),
                                  opacity: _searchLoading ? 1 : 0,
                                  child: Center(
                                    child: LoadingIndicator(
                                      indicatorType: Indicator.ballScale,
                                      colors: [
                                        Theme.of(context).colorScheme.secondary,
                                      ],
                                      strokeWidth: 50,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _cameraIsVisible
                                    ? Column(
                                        children: [
                                          Material(
                                            color: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            child: InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Icon(
                                                      Icons.camera_alt_outlined,
                                                      size: 35,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              onTap: () => _toScan(),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      )
                                    : Container(),
                                CustomElevatedButton(
                                    icon: Icon(Icons.add_outlined),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    title: "Ajouter manuellement",
                                    onPress: () async {
                                      setState(() {
                                        _isInRoot = false;
                                      });
                                      await Navigator.of(context)
                                          .pushNamed("/add/wine");
                                      setState(() {
                                        _isInRoot = true;
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Container(),
      ),
    );
  }
}
