import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/auth/auth_bloc.dart';
import 'package:ht_web/auth/event/auth_event.dart';
import 'package:ht_web/auth/state/auth_state.dart';
import 'package:ht_web/conf/shared/secure_storage.dart';
import 'package:ht_web/feature/landing/widget/sign_in.dart';
import 'package:ht_web/feature/landing/widget/sign_up.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool auth = false;
  late AuthNotifire _notifire;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _notifire = AuthNotifire(false, context: context);
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) => _notifire.isAuthentic(context),
    );
    _update();
  }

  @override
  void dispose() {
    _timer.cancel();
    _notifire.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBLOC, AuthState>(
      listener: (context, state) {
        if (state.event is SignOut) {
          setState(() {
            auth = true;
          });
        } else if (state.event is AuthLoginSuccess) {
          setState(() {
            auth = false;
          });
        }
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _notifire,
        builder: (context, value, child) => child!,
        child: SliverAppBar(
          expandedHeight: 260,
          stretch: true,
          pinned: true,
          centerTitle: true,
          title: _title(context),
          actions: auth
              ? _action
              : [
                  TextButton(
                    onPressed: () =>
                        context.read<AuthBLOC>().add(const SignOut()),
                    child: const Text("Sign Out"),
                  )
                ],
        ),
      ),
    );
  }

  Center _title(BuildContext context) {
    return const Center(
      child: Text("Health Thought Center"),
    );
  }

  List<Widget> get _action => [
        TextButton(
          onPressed: () => _dialog(body: const SignIn()),
          child: const Text("Sign In"),
        ),
        TextButton(
          onPressed: () => _dialog(body: const SignUp()),
          child: const Text("Sign Up"),
        ),
      ];

  void _dialog({required Widget body}) {
    context.read<AuthBLOC>().add(const AuthInintEvent());
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => body,
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

class AuthNotifire extends ValueNotifier<bool> {
  AuthNotifire(super.value, {required this.context});

  final BuildContext context;
  void isAuthentic(BuildContext context) async {
    log('Start Checking', name: 'Auth Notifire');
    final cred = await SecureStorage.instance.read();

    if (JwtDecoder.tryDecode(cred['token']!) == null) {
      log('Invalid Token', name: 'Auth Notifire');
      value = false;
      notifyListeners();
      return;
    }

    if (JwtDecoder.isExpired(cred['token']!)) {
      log('Token Expired', name: 'Auth Notifire');
      if (JwtDecoder.tryDecode(cred['refToken']!) == null) {
        log('Invalid Refresh Token', name: 'Auth Notifire');
        value = false;
        notifyListeners();
        return;
      }
      if (JwtDecoder.isExpired(cred['refToken']!)) {
        log('Refresh Token Expired', name: 'Auth Notifire');
        value = false;
        notifyListeners();
        return;
      }
      log('Revoke Token', name: 'Auth Notifire');
      _requestRefresh();
    }
    log('Token Is Still valid', name: 'Auth Notifire');
    value = true;
    notifyListeners();
  }

  void _requestRefresh() =>
      context.read<AuthBLOC>().add(const TokenExpiredOrNull());
}
