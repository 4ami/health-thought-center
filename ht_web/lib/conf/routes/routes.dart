part of 'app_router.dart';

final class _Routes {
  _Routes._();

  final _HomeRoutes _homeRoutes = _HomeRoutes.instance;

  static final _Routes _instance = _Routes._();
  static _Routes get instance => _instance;

  GoRouter get goRouter {
    return GoRouter(
      initialLocation: '/',
      routes: [..._homeRoutes.routes],
      redirect: _redirection,
    );
  }

  FutureOr<String?> _redirection(
    BuildContext context,
    GoRouterState state,
  ) async {
    try {
      //before redirection check where to go ?
      //if path need authorization check role
      //watch the current authentication event

      final AuthEvent currentEvent = context.read<AuthBLOC>().state.event;
      log(
        'User attempt to access [${state.matchedLocation}]',
        name: 'Redirection',
      );

      final isAuthorized = await _checkUserAuthorization;

      //Check authevent if login must check user role and redirect based on role authorization

      //User successfully logged in
      if (currentEvent is AuthLoginSuccess) {
        //is user try to access protected routes
        if (state.matchedLocation == '/trainer') {
          //User has authorization
          if (isAuthorized) {
            log(
              'User Is Authorized To Access Protected Route [/trainer]',
              name: 'Protected Redirection',
            );
            return null;
          }
          //User has'nt authorization
          log(
            'User Is Not Authorized To Access Protected Route [/trainer], User Redirected to [/]',
            name: 'Protected Redirection',
          );
          return '/';
        }

        if (isAuthorized && state.matchedLocation == '/trainer') {
          log('User already on authorized trainer path', name: 'Redirection');
          return null;
        } else if (!isAuthorized && state.matchedLocation != '/trainer') {
          log('User already on unauthorized path', name: 'Redirection');
          return null;
        }

        //User attempt to access trainee public routes
        if (isAuthorized) {
          log(
            'User Has [TRAINER] Role, And Try To Access Trainee Routes Without Authorization [${state.matchedLocation}], User Redirected To [/trainer]',
            name: 'Protected Redirection',
          );
          return '/trainer';
        }
        //User is Trainee
        log(
          'User Has [USER] Role, User Is Authorized To Access [${state.matchedLocation}].',
          name: 'Protected Redirection',
        );
        return null;
      }

      //User is Trainer And Try to access Trainee Routes while signed out
      //User Role [TRAINER]
      if (isAuthorized) {
        //User Attempt To Access Trainee Routes
        if (state.matchedLocation != '/trainer') {
          log(
            name: 'Trainer Authorized Routes',
            'Trainer Attempt To Access Trainee Route [${state.matchedLocation}]. Trainer Redirected to [/trainer].',
          );
          return '/trainer';
        }
      }

      //Event is Not AuthLoginSuccess
      //Try access Trainer Panel when is not logged in
      if (state.matchedLocation == '/trainer' && isAuthorized) {
        log(
          'TRAINER Is\'nt Logged In, And Try To Access Protected Route [/trainer].(ACCESS APPROVED!).',
          name: 'UnAuthenticated Access',
        );
        return null;
      }

      if (state.matchedLocation == '/trainer' && !isAuthorized) {
        log(
          'User Is\'nt Logged In, And Try To Access Protected Route [/trainer]. User Redirected To [/] (ACCESS DENIED!).',
          name: 'UnAuthenticated Access',
        );
        return '/';
      }

      return null;
    } catch (e) {
      log(
        "[Redirection Exception]:\n$e",
        name: '[Redirection Exception]',
        error: e,
      );
      return '/';
    }
  }

  Future<bool> get _checkUserAuthorization async {
    try {
      final cred = await SecureStorage.instance.read();

      if (JwtDecoder.tryDecode(cred['token']!) == null) {
        log('User Does Not Has Credentials (Invalid Token)',
            name: 'Authorization Check');
        return false;
      }

      final String role = JwtDecoder.decode(cred['token']!)['role'];

      log('User role is [$role]', name: 'Authorization Check');

      return role == 'TRAINER';
    } catch (e) {
      log(
        "[User Authorization Exception]",
        name: '[User Authorization Exception]',
        error: e,
      );
      return false;
    }
  }
}
