import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_web/auth/auth_bloc.dart';
import 'package:ht_web/auth/event/auth_event.dart';
import 'package:ht_web/auth/state/auth_state.dart';
import 'package:ht_web/conf/responsive.dart';
import 'package:ht_web/conf/shared/loading.dart';
import 'package:ht_web/feature/landing/layout/desktop.dart';
import 'package:ht_web/feature/landing/layout/mobile.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBLOC, AuthState>(
      listener: _authListener,
      child: Stack(
        children: [
          const Responsive(desktop: DeskTop(), mobile: Mobile()),
          if (context.watch<AuthBLOC>().state.event is AuthPending)
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
      context.replace('/');
    } else if (state.event is TokenExpiredOrNull) {
      context.read<AuthBLOC>().add(const RefreshToken());
      log('Try Revoke Token');
    } else if (state.event is RefreshTokenSuccess) {
      context.go('/');
    } else if (state.event is SignOut) {
      context.replace('/');
    }
  }
}
