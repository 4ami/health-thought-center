part of 'app_router.dart';

enum HomeRoutes { main, policy, trainer, zoomGuide, remoteGuide }

final class _HomeRoutes {
  _HomeRoutes._();
  static final _HomeRoutes _instance = _HomeRoutes._();
  static _HomeRoutes get instance => _instance;

  String path({required HomeRoutes route}) {
    switch (route) {
      case HomeRoutes.main:
        return '/';
      case HomeRoutes.policy:
        return '/terms-of-use';
      case HomeRoutes.trainer:
        return '/trainer';
      case HomeRoutes.zoomGuide:
        return '/zoom-guide';
      case HomeRoutes.remoteGuide:
        return '/remote-guide';
      default:
        return '/';
    }
  }

  List<GoRoute> get routes =>
      [_mainRoute, _policyRoute, _trainerRoute, _courses, _guid, _remoteGuid];

  final GoRoute _mainRoute = GoRoute(
    path: '/',
    name: 'Home',
    pageBuilder: (context, state) => const NoTransitionPage(child: Landing()),
  );

  final GoRoute _policyRoute = GoRoute(
    path: '/terms-of-use',
    name: 'TermsOfUse',
    pageBuilder: (context, state) => const NoTransitionPage(child: Policy()),
  );
  final GoRoute _trainerRoute = GoRoute(
    path: '/trainer',
    name: 'Trainer',
    pageBuilder: (context, state) => NoTransitionPage(
      child: BlocProvider<TrainerBLOC>(
        create: (context) => TrainerBLOC()..add(const TrainerRequestCourses()),
        child: const Trainer(),
      ),
    ),
  );

  final GoRoute _courses = GoRoute(
    path: '/courses',
    name: 'Courses',
    pageBuilder: (context, state) => NoTransitionPage(
      child: BlocProvider<CourseBLOC>(
        create: (context) => CourseBLOC()..add(const GETAllCoursesRequest()),
        child: const Courses(),
      ),
    ),
  );

  final GoRoute _guid = GoRoute(
    path: '/zoom-guide',
    name: 'Zoom Guide',
    pageBuilder: (context, state) => NoTransitionPage(
      child: BlocProvider<CourseBLOC>(
        create: (context) => CourseBLOC()..add(const GETAllCoursesRequest()),
        child: const Guide(),
      ),
    ),
  );
  final GoRoute _remoteGuid = GoRoute(
    path: '/remote-guide',
    name: 'Remote Guide',
    pageBuilder: (context, state) => NoTransitionPage(
      child: BlocProvider<CourseBLOC>(
        create: (context) => CourseBLOC()..add(const GETAllCoursesRequest()),
        child: const RemoteGuide(),
      ),
    ),
  );
}
