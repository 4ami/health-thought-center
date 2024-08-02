import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/conf/shared/drawer.dart';
import 'package:ht_web/conf/shared/footer.dart';
import 'package:ht_web/conf/shared/header.dart';
import 'package:ht_web/feature/landing/bloc/course_bloc.dart';
import 'package:ht_web/feature/landing/widget/course_builder.dart';
import 'package:ht_web/feature/landing/widget/search.dart';

class CourseMobile extends StatefulWidget {
  const CourseMobile({super.key});

  @override
  State<CourseMobile> createState() => _CourseMobileState();
}

class _CourseMobileState extends State<CourseMobile> {
  @override
  Widget build(BuildContext context) {
  final state = context.watch<CourseBLOC>().state;
    return Scaffold(
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          const Header(),
          const Search(),
          if (state.all.isNotEmpty)
            _heading(context),
          if (state.all.isNotEmpty)
            CourseBuilder(
              courses: context.watch<CourseBLOC>().state.all,
              length: context.watch<CourseBLOC>().state.all.length,
              isMobile: true,
            ),
          const Footer(),
        ],
      ),
    );
  }

  SliverToBoxAdapter _heading(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Text(
          "All Courses",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
