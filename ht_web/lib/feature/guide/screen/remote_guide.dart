import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_web/auth/auth_bloc.dart';
import 'package:ht_web/auth/event/auth_event.dart';
import 'package:ht_web/auth/state/auth_state.dart';
import 'package:ht_web/conf/shared/drawer.dart';
import 'package:ht_web/conf/shared/footer.dart';
import 'package:ht_web/conf/shared/header.dart';

class RemoteGuide extends StatefulWidget {
  const RemoteGuide({super.key});

  @override
  State<RemoteGuide> createState() => _RemoteGuideState();
}

class _RemoteGuideState extends State<RemoteGuide> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBLOC, AuthState>(
      listener: _authListener,
      child: Scaffold(
        drawer: const CustomDrawer(),
        body: CustomScrollView(
          slivers: [
            const Header(),
            SliverFillRemaining(child: Image.asset('assets/image/s1.png')),
            SliverFillRemaining(child: Image.asset('assets/image/s2.png')),
            SliverFillRemaining(child: Image.asset('assets/image/s3.png')),
            SliverFillRemaining(child: Image.asset('assets/image/s4.png')),
            SliverFillRemaining(child: Image.asset('assets/image/s5.png')),
            const Footer(),
          ],
        ),
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
}
