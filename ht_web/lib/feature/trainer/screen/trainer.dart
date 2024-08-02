import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_web/auth/auth_bloc.dart';
import 'package:ht_web/auth/event/auth_event.dart';
import 'package:ht_web/auth/state/auth_state.dart';
import 'package:ht_web/conf/responsive.dart';
import 'package:ht_web/conf/shared/loading.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_bloc.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_event.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_state.dart';
import 'package:ht_web/feature/trainer/layout/desktop.dart';
import 'package:ht_web/feature/trainer/layout/mobile.dart';

class Trainer extends StatelessWidget {
  const Trainer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBLOC, AuthState>(listener: _authListener),
        BlocListener<TrainerBLOC, TrainerState>(listener: _trainerListener),
      ],
      child: Stack(
        children: [
          const Responsive(desktop: DeskTop(), mobile: Mobile()),
          if (context.watch<TrainerBLOC>().state.event is TrainerRequestPending)
            const Loading()
        ],
      ),
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state.event is AuthLoginSuccess) {
      context.pop();
      context.replace('/trainer');
    } else if (state.event is TokenExpiredOrNull) {
      context.read<AuthBLOC>().add(const RefreshToken());
      log('Try Revoke Trainer Token');
    } else if (state.event is SignOut) {
      context.replace('/');
    }
  }

  void _trainerListener(BuildContext context, TrainerState state) {
    if (state.event is TrainerAddCourseSuccess) {
      context.pop();
      _dialog(context, state.event.message ?? "Success", state.event);
    } else if (state.event is TrainerAddCourseFailed) {
      context.pop();
      _dialog(context, state.event.message ?? "Failed", state.event);
    }
  }

  void _dialog(BuildContext context, String message, TrainerEvent event) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(50),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: event is TrainerAddCourseSuccess
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
                        color: event is TrainerAddCourseSuccess
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
