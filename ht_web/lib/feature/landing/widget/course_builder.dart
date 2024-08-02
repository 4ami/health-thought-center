// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_web/auth/auth_bloc.dart';
import 'package:ht_web/auth/event/auth_event.dart';
import 'package:ht_web/business/course/model/course.dart';
import 'package:ht_web/conf/shared/secure_storage.dart';
import 'package:ht_web/feature/landing/bloc/course_bloc.dart';
import 'package:ht_web/feature/landing/bloc/course_event.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CourseBuilder extends StatelessWidget {
  const CourseBuilder({
    super.key,
    required this.courses,
    required this.length,
    this.isMobile = false,
  });

  final List<Course> courses;
  final int length;
  final bool isMobile;
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) => SliverGrid.builder(
          gridDelegate: _delegate(constraints),
          itemBuilder: (context, i) {
            return Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18),
                child: _cardBody(i, context),
              ),
            );
          },
          itemCount: length,
        ),
      ),
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
        _enroll(context, i)
      ],
    );
  }

  SizedBox _enroll(BuildContext context, int i) {
    return SizedBox(
      height: 40,
      width: 100,
      child: FloatingActionButton(
        onPressed: () async {
          try {
            //is not auth
            final cred = await SecureStorage.instance.read();
            if (context.read<AuthBLOC>().state.event is! AuthLoginSuccess) {
              //no token
              if (cred['token'] == null || cred['token']!.isEmpty) {
                _show(context);
                return;
              }
              //there is token but no refresh
              if (cred['refToken'] == null || cred['refToken']!.isEmpty) {
                _show(context);
                return;
              }
              //invalid token
              if (JwtDecoder.tryDecode(cred['token']!) == null) {
                _show(context);
                return;
              }
              //invalid refresh
              if (JwtDecoder.tryDecode(cred['refToken']!) == null) {
                _show(context);
                return;
              }
              //expired refresh
              if (JwtDecoder.isExpired(cred['refToken']!)) {
                _show(context);
                return;
              }
              //token expired but refresh is still
              if (JwtDecoder.isExpired(cred['token']!)) {
                await Future(
                    () => context.read<AuthBLOC>().add(const RefreshToken()));

                final tokens = await SecureStorage.instance.read();

                if (tokens['token'] != null || tokens['token']!.isNotEmpty) {
                  if (JwtDecoder.isExpired(tokens['token']!)) {
                    log('REVOKED WELL');
                  }
                }
              }
            }
            final String uid = JwtDecoder.decode(cred['token']!)['_id'];
            context.read<CourseBLOC>().add(
                  NewEnroll(
                    uid: uid,
                    cid: courses[i].id,
                    price: courses[i].price,
                  ),
                );
            log('Enrolled !');
          } catch (e) {
            log('[Enroll ERROR]: $e');
          }
        },
        child: const Text("Enroll Now"),
      ),
    );
  }

  void _show(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(50),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: style(context),
          child: SizedBox(
            width: 450,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Please Sign in if you already registered, or sign up to complete your enrollment.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Dismiss'))
              ],
            ),
          ),
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

  SliverGridDelegateWithFixedCrossAxisCount _delegate(
      SliverConstraints constraints) {
    if (isMobile) {
      return const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1);
    }
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: constraints.crossAxisExtent < 786 ? 1 : 3,
    );
  }
}
