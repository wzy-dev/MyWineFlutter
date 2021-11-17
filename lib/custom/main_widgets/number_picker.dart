import 'package:flutter/material.dart';

class CustomNumberPicker extends StatefulWidget {
  const CustomNumberPicker(
      {Key? key,
      required this.value,
      required this.onChange,
      required this.minValue,
      required this.maxValue})
      : super(key: key);

  final int value;
  final Function(int) onChange;
  final int minValue;
  final int maxValue;

  @override
  _CustomNumberPickerState createState() => _CustomNumberPickerState();
}

class _CustomNumberPickerState extends State<CustomNumberPicker> {
  late int _initialPage;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.value - widget.minValue,
      viewportFraction: 0.1,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.white,
              Color.fromRGBO(0, 0, 0, 0),
              Color.fromRGBO(0, 0, 0, 0),
              Colors.white
            ],
            stops: [0.0, 0.2, 0.8, 1.0],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: PageView.builder(
          itemCount: widget.maxValue - widget.minValue + 1,
          controller: _pageController,
          onPageChanged: (int index) =>
              widget.onChange(index + widget.minValue),
          itemBuilder: (_, i) {
            bool isSelected = i + widget.minValue == widget.value;
            return InkWell(
              onTap: () {
                widget.onChange(i + widget.minValue);
                _pageController.jumpToPage(i);
                print('j');
              },
              child: Transform.scale(
                scale: isSelected ? 1 : 0.7,
                child: Center(
                  child: Text(
                    (i + widget.minValue).toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: isSelected ? FontWeight.bold : null,
                      color: isSelected
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.black54,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
