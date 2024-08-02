import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/conf/shared/loading.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_bloc.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_event.dart';
import 'package:ht_web/feature/trainer/widget/responsive_form.dart';

class CourseForm extends StatefulWidget {
  const CourseForm({super.key, this.isMobile = false});
  final bool isMobile;
  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(50),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: style(context),
        child: Stack(
          children: [
            widget.isMobile ? const Mobile() : const DeskTop(),
            if (context.watch<TrainerBLOC>().state.event
                is TrainerRequestPending)
              const Loading()
          ],
        ),
      ),
    );
  }

  BoxDecoration style(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Theme.of(context).colorScheme.background,
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.onPrimary,
          blurRadius: 32,
          offset: -const Offset(3, 3),
        ),
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withOpacity(.4),
          blurRadius: 32,
          offset: const Offset(18, 18),
        ),
      ],
    );
  }
}
