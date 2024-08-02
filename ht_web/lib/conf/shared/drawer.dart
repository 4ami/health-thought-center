import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_web/auth/auth_bloc.dart';
import 'package:ht_web/auth/event/auth_event.dart';
import 'package:ht_web/auth/state/auth_state.dart';
import 'package:ht_web/conf/routes/app_router.dart';
import 'package:ht_web/conf/shared/secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool auth = false;
  @override
  void initState() {
    super.initState();

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBLOC, AuthState>(
      listener: (context, state) {
        if (state.event is SignOut) {
          setState(() {
            auth = true;
          });
        }
        if (state.event is AuthLoginSuccess) {
          setState(() {
            auth = false;
          });
        }
      },
      child: Drawer(
        child: !auth ? const _Authenticated() : const _UnAuthenticated(),
      ),
    );
  }

  Future<bool> _isAuth() async {
    final cred = await SecureStorage.instance.read();
    if (cred['token'] == null) return true;

    try {
      if (JwtDecoder.tryDecode(cred['token']!) == null) return true;
      return JwtDecoder.isExpired(cred['token']!);
    } catch (e) {
      log('HEADER: $e');
      return false;
    }
  }

  void _update() async {
    auth = await _isAuth();
    if (auth) _refreshToken();
    log('Is Expired? $auth');
    setState(() {
      auth;
    });
  }

  void _refreshToken() {
    final event = context.read<AuthBLOC>().state.event;
    if (event is! SignOut && event is! AuthInintEvent) {
      context.read<AuthBLOC>().add(const TokenExpiredOrNull());
    }
  }
}

class _Authenticated extends StatelessWidget {
  const _Authenticated();

  @override
  Widget build(BuildContext context) {
    String name = context.read<AuthBLOC>().state.fname;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 50),
          child: Text(
            "Welcom ${name.isEmpty ? 'User' : name}",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 50),
        const Divider(indent: 5, endIndent: 5),
        MenuItemButton(
          onPressed: () {
            context.go(AppRouter.instance.pathOfHome(route: HomeRoutes.main));
          },
          leadingIcon: const Icon(Icons.home),
          child: const Text("Home"),
        ),
        // const Divider(indent: 5, endIndent: 5),
        // MenuItemButton(
        //   onPressed: () {},
        //   leadingIcon: const Icon(Icons.shop_2),
        //   child: const Text("Cart"),
        // ),
        const Divider(indent: 5, endIndent: 5),
        MenuItemButton(
          onPressed: () => context.go('/courses'),
          leadingIcon: const Icon(Icons.video_collection_outlined),
          child: const Text("Courses"),
        ),
        const Divider(indent: 5, endIndent: 5),
        MenuItemButton(
          onPressed: () {
            context.go(
              AppRouter.instance.pathOfHome(route: HomeRoutes.policy),
            );
          },
          leadingIcon: const Icon(Icons.policy_outlined),
          child: const Text("Terms of Use"),
        ),
        const Divider(indent: 5, endIndent: 5),
        MenuItemButton(
          onPressed: () {
            context.go(
              AppRouter.instance.pathOfHome(route: HomeRoutes.zoomGuide),
            );
          },
          leadingIcon: const Icon(Icons.tour_outlined),
          child: const Text("Zoom Guide"),
        ),
        const Divider(indent: 5, endIndent: 5),
        MenuItemButton(
          onPressed: () {
            context.go(
              AppRouter.instance.pathOfHome(route: HomeRoutes.remoteGuide),
            );
          },
          leadingIcon: const Icon(Icons.tour_outlined),
          child: const Text("Sync Training Guide"),
        ),
        const Divider(indent: 5, endIndent: 5),
        MenuItemButton(
          onPressed: () => context.read<AuthBLOC>().add(const SignOut()),
          leadingIcon: const Icon(Icons.logout_rounded),
          child: const Text("Sign Out"),
        ),
        const Divider(indent: 5, endIndent: 5),
      ],
    );
  }
}

class _UnAuthenticated extends StatelessWidget {
  const _UnAuthenticated();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 50),
          child: Text(
            "Welcom Guest",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 50),
        const Divider(indent: 5, endIndent: 5),
        MenuItemButton(
          onPressed: () {
            context.go(AppRouter.instance.pathOfHome(route: HomeRoutes.main));
          },
          leadingIcon: const Icon(Icons.home),
          child: const Text("Home"),
        ),
        const Divider(indent: 5, endIndent: 5),
        MenuItemButton(
          onPressed: () => context.go('/courses'),
          leadingIcon: const Icon(Icons.video_collection_outlined),
          child: const Text("Courses"),
        ),
        const Divider(indent: 5, endIndent: 5),
        MenuItemButton(
          onPressed: () {
            context.go(
              AppRouter.instance.pathOfHome(route: HomeRoutes.policy),
            );
          },
          leadingIcon: const Icon(Icons.policy_outlined),
          child: const Text("Terms of Use"),
        ),
        const Divider(indent: 5, endIndent: 5),
        MenuItemButton(
          onPressed: () {
            context.go(
              AppRouter.instance.pathOfHome(route: HomeRoutes.zoomGuide),
            );
          },
          leadingIcon: const Icon(Icons.tour_outlined),
          child: const Text("Zoom Guide"),
        ),
        const Divider(indent: 5, endIndent: 5),
        MenuItemButton(
          onPressed: () {
            context.go(
              AppRouter.instance.pathOfHome(route: HomeRoutes.remoteGuide),
            );
          },
          leadingIcon: const Icon(Icons.tour_outlined),
          child: const Text("Sync Training Guide"),
        ),
        const Divider(indent: 5, endIndent: 5),
      ],
    );
  }
}
