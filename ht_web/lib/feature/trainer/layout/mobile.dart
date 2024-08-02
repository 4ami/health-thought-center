import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/conf/shared/footer.dart';
import 'package:ht_web/conf/shared/header.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_bloc.dart';
import 'package:ht_web/feature/trainer/widget/courses_builder.dart';
import 'package:ht_web/feature/trainer/widget/new_course.dart';

class Mobile extends StatefulWidget {
  const Mobile({super.key});

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrainerBLOC>.value(
      value: context.read<TrainerBLOC>(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const Header(),
            if (context.watch<TrainerBLOC>().state.courses.isNotEmpty)
              _heading(context),
            if (context.watch<TrainerBLOC>().state.courses.isNotEmpty)
              CourseBuilder(
                courses: context.watch<TrainerBLOC>().state.courses,
                length: context.watch<TrainerBLOC>().state.courses.length,
                isMobile: true,
              ),
            const Footer(),
          ],
        ),
        floatingActionButton: BlocProvider<TrainerBLOC>.value(
          value: context.read<TrainerBLOC>(),
          child: const NewCourse(isMobile: true),
        ),
      ),
    );
  }

  SliverToBoxAdapter _heading(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Text(
          "My Courses",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
