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
import 'package:pdfx/pdfx.dart';

class Guide extends StatefulWidget {
  const Guide({super.key});

  @override
  State<Guide> createState() => _GuideState();
}

class _GuideState extends State<Guide> {
  final PdfController controller =
      PdfController(document: PdfDocument.openAsset('assets/zoom_guide.pdf'));
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBLOC, AuthState>(
      listener: _authListener,
      child: Scaffold(
        drawer: const CustomDrawer(),
        body: CustomScrollView(
          slivers: [
            const Header(),
            SliverFillRemaining(
              child: PdfView(
                controller: controller,
                scrollDirection: Axis.vertical,
              ),
            ),
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
