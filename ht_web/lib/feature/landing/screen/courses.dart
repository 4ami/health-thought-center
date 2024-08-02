import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_web/auth/auth_bloc.dart';
import 'package:ht_web/auth/event/auth_event.dart';
import 'package:ht_web/auth/state/auth_state.dart';
import 'package:ht_web/conf/responsive.dart';
import 'package:ht_web/conf/shared/loading.dart';
import 'package:ht_web/feature/landing/bloc/course_bloc.dart';
import 'package:ht_web/feature/landing/bloc/course_event.dart';
import 'package:ht_web/feature/landing/bloc/course_state.dart';
import 'package:ht_web/feature/landing/layout/course_desktop.dart';
import 'package:ht_web/feature/landing/layout/course_mobile.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CourseBLOC, CourseState>(listener: _courseLitener),
        BlocListener<AuthBLOC, AuthState>(listener: _authListener)
      ],
      child: Stack(
        children: [
          const Responsive(desktop: CourseDeskTop(), mobile: CourseMobile()),
          if (context.watch<CourseBLOC>().state.event is CourseRequestPending)
            const Loading()
        ],
      ),
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state.event is AuthRegisterSuccess) {
      context.pop();
    } else if (state.event is AuthLoginSuccess) {
      context.pop();
      context.replace('/courses');
    } else if (state.event is TokenExpiredOrNull) {
      context.read<AuthBLOC>().add(const RefreshToken());
      log('Try Revoke Token');
    } else if (state.event is RefreshTokenSuccess) {
      context.go('/courses');
    } else if (state.event is SignOut) {
      context.replace('/courses');
    }
  }

  void _courseLitener(BuildContext context, CourseState state) {
    log(state.event.toString());
    if (state.event is EnrollSuccess) {
      _success(context, state.event.message ?? 'Success', state.event);
      log('Enroll Success Event');
    } else if (state.event is EnrollFail) {
      _success(context, state.event.message ?? 'Fail', state.event);
      log('Enroll Fail Event');
    }
  }

  void _success(BuildContext context, String message, CourseEvent event) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(50),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: event is EnrollSuccess
              ? _successStyle(context)
              : _failStyle(context),
          child: SizedBox(
            width: 450,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  message,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: event is EnrollSuccess
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                      ),
                ),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Dismiss'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _successStyle(BuildContext context) {
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

  BoxDecoration _failStyle(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Theme.of(context).colorScheme.background,
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.error.withOpacity(.3),
          blurRadius: 32,
          offset: -const Offset(3, 3),
        ),
        BoxShadow(
          color: Theme.of(context).colorScheme.error.withOpacity(.8),
          blurRadius: 20,
          offset: const Offset(8, 8),
        ),
      ],
    );
  }
}
