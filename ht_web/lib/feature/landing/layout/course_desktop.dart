import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/conf/shared/drawer.dart';
import 'package:ht_web/conf/shared/footer.dart';
import 'package:ht_web/conf/shared/header.dart';
import 'package:ht_web/feature/landing/bloc/course_bloc.dart';
import 'package:ht_web/feature/landing/bloc/course_event.dart';
import 'package:ht_web/feature/landing/widget/course_builder.dart';
import 'package:ht_web/feature/landing/widget/search.dart';

class CourseDeskTop extends StatefulWidget {
  const CourseDeskTop({super.key});

  @override
  State<CourseDeskTop> createState() => _CourseDeskTopState();
}

class _CourseDeskTopState extends State<CourseDeskTop> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseBLOC>().state;
    return Scaffold(
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          const Header(),
          const Search(),
          if (state.event is SearchSuccess)
            _heading(context, "Search Results: ${state.request}"),
          if (state.event is SearchPending)
            const SliverToBoxAdapter(
              child: Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          if (state.event is SearchSuccess && state.response.isEmpty)
            _notFound(context),
          if (state.event is SearchSuccess)
            CourseBuilder(
              courses: context.watch<CourseBLOC>().state.response,
              length: context.watch<CourseBLOC>().state.response.length,
            ),
          if (state.all.isNotEmpty) _heading(context, "All Courses"),
          if (state.all.isNotEmpty)
            CourseBuilder(
              courses: context.watch<CourseBLOC>().state.all,
              length: context.watch<CourseBLOC>().state.all.length,
            ),
          const Footer(),
        ],
      ),
    );
  }

  SliverToBoxAdapter _heading(BuildContext context, String label) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Text(
          label,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }

  SliverToBoxAdapter _notFound(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50),
        child: Text(
          textAlign: TextAlign.center,
          "Sorry There Is No Course Match Your Request",
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
