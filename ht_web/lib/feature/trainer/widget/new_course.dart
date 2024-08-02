import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_bloc.dart';
import 'package:ht_web/feature/trainer/widget/course_form.dart';

class NewCourse extends StatelessWidget {
  const NewCourse({
    super.key,
    this.isMobile = false,
  });

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _show(context),
      tooltip: 'Add New Course',
      child: const Icon(Icons.add),
    );
  }

  void _show(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<TrainerBLOC>(),
        child: CourseForm(isMobile: isMobile),
      ),
    );
  }
}
