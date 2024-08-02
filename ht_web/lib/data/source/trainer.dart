import 'package:flutter_dotenv/flutter_dotenv.dart';

final class TrainerSource {
  TrainerSource._();
  static final TrainerSource _instacne = TrainerSource._();
  static TrainerSource get instance => _instacne;

  final String _host =
      dotenv.get('SERVER_HOST', fallback: 'SERVER_HOST = NULL');
  final String _port =
      dotenv.get('SERVER_PORT', fallback: 'SERVER_PORT = NULL');

  String get api => '$_host:$_port';

  final String _trainerRoute =
      dotenv.get('TRAINER_PATH', fallback: 'TRAINER_PATH = NULL');

  final String _trainerV =
      dotenv.get('TRAINER_V', fallback: 'TRAINER_V = NULL');

  String get _path => '$_trainerRoute$_trainerV';

  final String _trainerCoursesEP = dotenv.get('TRAINER_COURSE_ENDPOINT',
      fallback: 'TRAINER_COURSE_ENDPOINT = NULL');

  String get trainerCoursesEP => '$_path$_trainerCoursesEP';

  final String _trainerCreateCourseEP = dotenv.get(
      'TRAINER_NEW_COURSE_ENDPOINT',
      fallback: 'TRAINER_NEW_COURSE_ENDPOINT = null');

  String get trainerCreateCourseEP => '$_path$_trainerCreateCourseEP';
}
