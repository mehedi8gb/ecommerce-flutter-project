import 'package:flutter/widgets.dart';

class HeaderLogo extends StatelessWidget {

  const HeaderLogo({
    Key? key,
    this.textColor = const Color(0xFF757575),
    this.style = FlutterLogoStyle.markOnly,
    this.duration = const Duration(milliseconds: 750),
    this.curve = Curves.fastOutSlowIn,
  }) : super(key: key);

  final Color textColor;

  final FlutterLogoStyle style;

  final Duration duration;

  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final double iconSize = 42;
    return AnimatedContainer(
      height: iconSize,
      duration: duration,
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
