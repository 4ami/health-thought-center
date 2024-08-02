import 'dart:developer';

import 'package:flutter/widgets.dart';

class Responsive extends StatelessWidget {
  final Widget desktop, mobile;

  const Responsive({
    super.key,
    required this.desktop,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        log("[Screen Size]: ${constraints.maxWidth}");
        switch (constraints.maxWidth) {
          case < 600:
            return mobile;
          default:
            return desktop;
        }
      },
    );
  }
}
