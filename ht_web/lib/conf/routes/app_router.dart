library app_router;
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:ht_web/conf/shared/secure_storage.dart';
import 'package:ht_web/feature/guide/screen/guide.dart';
import 'package:ht_web/feature/guide/screen/remote_guide.dart';
import 'package:ht_web/feature/landing/bloc/course_bloc.dart';
import 'package:ht_web/feature/landing/bloc/course_event.dart';
import 'package:ht_web/feature/landing/screen/courses.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_bloc.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_event.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_web/auth/auth_bloc.dart';
import 'package:ht_web/auth/event/auth_event.dart';
import 'package:ht_web/feature/landing/screen/landing.dart';
import 'package:ht_web/feature/policy/screen/policy.dart';
import 'package:ht_web/feature/trainer/screen/trainer.dart';
part 'home_routes.dart';
part 'routes.dart';

final class AppRouter {
  AppRouter._(this._homeRoutes);

  final _HomeRoutes _homeRoutes;

  final _Routes _routes = _Routes.instance;

  static final AppRouter _instance = AppRouter._(_HomeRoutes.instance);

  static AppRouter get instance => _instance;

  GoRouterDelegate get delegate => _routes.goRouter.routerDelegate;
  RouteConfiguration get config => _routes.goRouter.configuration;
  GoRouteInformationParser get informationParser =>
      _routes.goRouter.routeInformationParser;
  GoRouteInformationProvider get informationProvider =>
      _routes.goRouter.routeInformationProvider;

  GoRouter get router => _routes.goRouter;

  String pathOfHome({required HomeRoutes route}) {
    return _homeRoutes.path(route: route);
  }
}
