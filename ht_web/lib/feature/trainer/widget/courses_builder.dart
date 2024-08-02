import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ht_web/business/course/model/course.dart';

class CourseBuilder extends StatelessWidget {
  const CourseBuilder({
    super.key,
    required this.courses,
    this.isMobile = false,
    required this.length,
  });

  final List<Course> courses;
  final int length;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          return SliverGrid.builder(
            gridDelegate: _delegate(constraints),
            itemBuilder: (context, i) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 18),
                  child: _cardBody(i, context),
                ),
              );
            },
            itemCount: length,
          );
        },
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _delegate(
      SliverConstraints constraints) {
    if (isMobile) {
      return const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1);
    }
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: constraints.crossAxisExtent < 786 ? 1 : 3,
    );
  }

  Column _cardBody(int i, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _name(i, context),
        _description(i, context),
        _mode(i, context),
        _price(i, context),
      ],
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

  Text _price(int i, BuildContext context) {
    return Text(
      '${courses[i].price.toStringAsFixed(2)} SAR',
      style: Theme.of(context).textTheme.titleSmall,
    );
  }

  Text _mode(int i, BuildContext context) {
    return Text(
      courses[i].mode,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Text _description(int i, BuildContext context) {
    return Text(
      courses[i].description,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }

  Text _name(int i, BuildContext context) {
    return Text(
      courses[i].name,
      style: Theme.of(context).textTheme.titleLarge,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
}
