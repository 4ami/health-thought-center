import 'package:flutter/material.dart';

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _heading,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: _body,
        )
      ],
    );
  }

  Text get _heading => Text(
        textAlign: TextAlign.center,
        "Welcome to Health Thought Center",
        style: Theme.of(context).textTheme.headlineMedium,
      );

  Text get _body => Text(
        """
At Health Thought Center, we believe that excellence in healthcare begins with continuous learning and development. 
We provide specialized medical training programs designed to enhance the skills and knowledge of medical professionals. 
Our goal is to support medical specialists in delivering the highest quality care to their patients.
        """,
        style: Theme.of(context).textTheme.bodyLarge,
      );
}
