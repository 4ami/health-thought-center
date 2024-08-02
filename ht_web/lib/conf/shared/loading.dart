import 'dart:ui';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 6),
          child: const CircularProgressIndicator(strokeWidth: 8),
        ),
      ),
    );
  }
}
