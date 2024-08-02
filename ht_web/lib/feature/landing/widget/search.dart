import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/feature/landing/bloc/course_bloc.dart';
import 'package:ht_web/feature/landing/bloc/course_event.dart';

class Search extends StatelessWidget {
  const Search({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * .25, vertical: 35),
        child: TextFormField(
          decoration: const InputDecoration(label: Text('Search')),
          onChanged: (value) {
            context.read<CourseBLOC>().add(
                  SearchRequestChanged(request: value),
                );
          },
        ),
      ),
    );
  }
}
