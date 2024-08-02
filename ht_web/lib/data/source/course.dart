import 'package:flutter_dotenv/flutter_dotenv.dart';

class CourseSource {
  CourseSource._();

  static final CourseSource _instance = CourseSource._();
  static CourseSource get instance => _instance;

  final String _host =
      dotenv.get('SERVER_HOST', fallback: 'SERVER_HOST = NULL');
  final String _port =
      dotenv.get('SERVER_PORT', fallback: 'SERVER_PORT = NULL');

  String get api => '$_host:$_port';

  final String _path =
      dotenv.get('COURSE_PATH', fallback: '[COURSE_PATH] = NULL');
  final String _version = dotenv.get('COURSE_V', fallback: '[COURSE_V] = NULL');

  String get _courseRoute => '$_path$_version';

  final String _allCoursesEP = dotenv.get('ALL_COURSES_ENDPOINT',
      fallback: '[ALL_COURSES_ENDPOINT] = NULL');

  String get allCoursesEP => '$_courseRoute$_allCoursesEP';

  final String _enrollEP = dotenv.get('ENROLLMENT_ENDPOINT',
      fallback: '[ENROLLMENT_ENDPOINT] = NULL');

  String get enrollEP => '$_courseRoute$_enrollEP';

  String get serchEP => _courseRoute;
}
