import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Corner extends StatelessWidget {
  const Corner({
    Key? key,
    required bool loading,
  })  : _loading = loading,
        super(key: key);

  final bool _loading;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: _loading ? 0 : 1,
      child: SvgPicture.asset(
        'assets/svg/rounded_angle.svg',
        height: 50,
        width: 50,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
