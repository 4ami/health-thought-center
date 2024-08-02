import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      // hasScrollBody: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _divider(),
          const Text("Health Thought Center ©"),
          _divider(),
        ],
      ),
    );
  }

  Expanded _divider() {
    return const Expanded(
      child: Divider(
        indent: 25,
        endIndent: 25,
      ),
    );
  }
}
