import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:mywine/shelf.dart';

class RekognizeProvider {
  static Future<AutoRefreshingAuthClient> _client =
      CredentialsProvider().client;

  static Future<BatchAnnotateImagesResponse> search(String image) async {
    return _client.then((value) async {
      var _vision = VisionApi(value);

      var _api = _vision.images;
      var _response = await _api.annotate(BatchAnnotateImagesRequest.fromJson({
        "requests": [
          {
            "image": {"content": image},
            "features": [
              {
                "type": "DOCUMENT_TEXT_DETECTION",
              }
            ]
          }
        ]
      }));

      return _response;
    }).timeout(Duration(seconds: 10), onTimeout: () async {
      return BatchAnnotateImagesResponse();
    }).onError((error, stackTrace) {
      return BatchAnnotateImagesResponse();
    });
  }
}
