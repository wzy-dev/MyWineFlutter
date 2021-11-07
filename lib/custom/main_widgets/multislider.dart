import 'package:flutter/material.dart';

class MultiSliderArguments {
  MultiSliderArguments(
      {this.min,
      this.max,
      this.minimumIsEnabled = false,
      this.maximumIsEnabled = false});

  final int? min;
  final int? max;

  final bool minimumIsEnabled;
  final bool maximumIsEnabled;
}

class MultiSlider extends StatefulWidget {
  const MultiSlider({
    Key? key,
    required this.onChange,
    required this.suffix,
    required this.minVal,
    required this.maxVal,
    required this.minPossible,
    this.minimumIsEnabled = false,
    this.maximumIsEnabled = false,
  }) : super(key: key);

  final Function(MultiSliderArguments) onChange;
  final Function(int) suffix;
  final int minVal;
  final int maxVal;
  final int minPossible;
  final bool minimumIsEnabled;
  final bool maximumIsEnabled;

  @override
  State<MultiSlider> createState() => _MultiSliderState();
}

class _MultiSliderState extends State<MultiSlider> {
  late bool _minimumIsEnabled;
  late bool _maximumIsEnabled;

  late double _minimumPossible;
  late double _maximumPossible;

  late double _minVal;
  late double _maxVal;

  @override
  void initState() {
    _minimumIsEnabled = widget.minimumIsEnabled;
    _maximumIsEnabled = widget.maximumIsEnabled;

    _minVal = widget.minVal.roundToDouble();
    _maxVal = widget.maxVal.roundToDouble();

    _minimumPossible = widget.minPossible.roundToDouble();
    _maximumPossible = _maxVal + 10;

    if (_minVal > _maxVal && !_maximumIsEnabled) {
      _maxVal = _maxVal + _maximumPossible / 3 + 3;
    } else if (_minVal >= _maxVal && !_minimumIsEnabled) {
      _minVal = _maxVal - _maximumPossible / 3 - 3;
    } else if (_minVal > _maxVal) {
      _minVal = widget.maxVal.roundToDouble();
      _maxVal = widget.minVal.roundToDouble();
    }
    if (_maxVal >= _maximumPossible) _maximumPossible = _maxVal + 3;
    if (_minVal <= _minimumPossible) _minVal = _minimumPossible;

    super.initState();
  }

  OutlinedButton _drawButton(
      {required BuildContext context,
      required Function onPressed,
      required String label,
      required bool isSelected}) {
    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide(),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(isSelected
            ? Theme.of(context).colorScheme.secondary
            : Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(isSelected
            ? Colors.white
            : Theme.of(context).colorScheme.secondary),
      ),
      onPressed: () {
        onPressed();
        widget.onChange(
          MultiSliderArguments(
            min: (_minimumIsEnabled ? _minVal.round() : null),
            max: (_maximumIsEnabled ? _maxVal.round() : null),
            minimumIsEnabled: _minimumIsEnabled,
            maximumIsEnabled: _maximumIsEnabled,
          ),
        );
      },
      child: Text(
        label,
      ),
    );
  }

  String _writeDenseLabel(double value) {
    int roundedValue = value.round();
    bool needExtend = value == _maximumPossible.round() + 1;
    return needExtend ? "${roundedValue - 1} +" : roundedValue.toString();
  }

  Text _writeLabel(double value) {
    int roundedValue = value.round();
    bool needExtend = value == _maximumPossible.round() + 1;
    return Text(
        "${needExtend ? roundedValue - 1 : roundedValue} ${widget.suffix(value.round())} ${needExtend ? "+" : ""}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _drawButton(
              context: context,
              onPressed: () => setState(() {
                _minimumIsEnabled = !_minimumIsEnabled;
              }),
              label: "MINIMUM",
              isSelected: _minimumIsEnabled,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: AnimatedSize(
                duration: Duration(milliseconds: 200),
                child: _minimumIsEnabled
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: _writeLabel(_minVal),
                      )
                    : Container(),
              ),
            ),
            _drawButton(
              context: context,
              onPressed: () => setState(() {
                _maximumIsEnabled = !_maximumIsEnabled;
              }),
              label: "MAXIMUM",
              isSelected: _maximumIsEnabled,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: AnimatedSize(
                duration: Duration(milliseconds: 200),
                child: _maximumIsEnabled
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: _writeLabel(_maxVal),
                      )
                    : Container(),
              ),
            ),
          ],
        ),
        _minimumIsEnabled
            ? _maximumIsEnabled
                ? /* Minimum et Maximum */ RangeSlider(
                    min: _minimumPossible,
                    max: _maximumPossible + 1,
                    divisions: _maximumPossible.round() + 1,
                    labels: RangeLabels(
                      _writeDenseLabel(_minVal),
                      _writeDenseLabel(_maxVal),
                    ),
                    values: RangeValues(_minVal, _maxVal),
                    onChanged: (RangeValues values) => setState(() {
                      _minVal = values.start;
                      _maxVal = values.end;
                    }),
                    onChangeEnd: (values) {
                      if (values.start < _maximumPossible - 15 &&
                          values.end < _maximumPossible - 15) {
                        setState(() {
                          _maximumPossible = _maximumPossible - 14;
                        });
                      }
                      if (values.end.round() == _maximumPossible.round() + 1) {
                        setState(() {
                          _maximumPossible += 10;
                        });
                      }
                      widget.onChange(
                        MultiSliderArguments(
                          min: values.start.round(),
                          max: values.end.round(),
                          minimumIsEnabled: _minimumIsEnabled,
                          maximumIsEnabled: _maximumIsEnabled,
                        ),
                      );
                    },
                  )
                : /* Minimum seulement */ SliderTheme(
                    data: SliderThemeData(
                        // Inverser le track actif et inactif
                        activeTrackColor:
                            Theme.of(context).sliderTheme.inactiveTrackColor,
                        inactiveTrackColor:
                            Theme.of(context).sliderTheme.activeTrackColor,
                        thumbColor:
                            Theme.of(context).sliderTheme.activeTrackColor,
                        trackShape: RectangularSliderTrackShape()),
                    child: Slider(
                      min: _minimumPossible,
                      max: _maximumPossible + 1,
                      value: _minVal,
                      divisions: _maximumPossible.round() + 1,
                      label: _writeDenseLabel(_minVal),
                      onChanged: (minimum) {
                        if (_maxVal <= minimum) {
                          _maxVal = minimum + _maximumPossible / 3 + 3;
                        }
                        setState(() {
                          _minVal = minimum;
                        });
                      },
                      onChangeEnd: (minimum) {
                        if (_maxVal >= _maximumPossible)
                          _maximumPossible = _maxVal + 3;
                        if (minimum < _maximumPossible - 15 &&
                            _maxVal < _maximumPossible - 15) {
                          setState(() {
                            _maximumPossible = _maximumPossible - 14;
                          });
                        }
                        if (minimum.round() == _maximumPossible.round() + 1) {
                          setState(() {
                            _maximumPossible += 10;
                          });
                        }
                        widget.onChange(
                          MultiSliderArguments(
                            min: minimum.round(),
                            max: _maxVal.round(),
                            minimumIsEnabled: _minimumIsEnabled,
                            maximumIsEnabled: _maximumIsEnabled,
                          ),
                        );
                      },
                    ),
                  )
            : _maximumIsEnabled
                ? /* Maximum seulement */ Slider(
                    min: _minimumPossible,
                    max: _maximumPossible + 1,
                    value: _maxVal,
                    divisions: _maximumPossible.round() + 1,
                    label: _writeDenseLabel(_maxVal),
                    onChanged: (maximum) {
                      if (_minVal >= maximum) {
                        _minVal = maximum - _maximumPossible / 3 + 3;
                      }
                      setState(() {
                        _maxVal = maximum;
                      });
                    },
                    onChangeEnd: (maximum) {
                      if (_minVal <= _minimumPossible)
                        _minVal = _minimumPossible;
                      if (maximum < _maximumPossible - 15 &&
                          _minVal < _maximumPossible - 15) {
                        setState(() {
                          _maximumPossible = _maximumPossible - 14;
                        });
                      }
                      if (maximum.round() == _maximumPossible.round() + 1) {
                        setState(() {
                          _maximumPossible += 10;
                        });
                      }
                      widget.onChange(
                        MultiSliderArguments(
                          min: _minVal.round(),
                          max: maximum.round(),
                          minimumIsEnabled: _minimumIsEnabled,
                          maximumIsEnabled: _maximumIsEnabled,
                        ),
                      );
                    },
                  )
                : /* Disabled */ RangeSlider(
                    min: _minimumPossible,
                    max: _maximumPossible + 1,
                    values: RangeValues(_minVal, _maxVal),
                    onChanged: null)
      ],
    );
  }
}
