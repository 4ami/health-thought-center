import 'package:ht_web/data/model/new_course.dart';

sealed class TrainerEvent {
  final String? message;
  const TrainerEvent({this.message});
}

final class TrainerInitEvent extends TrainerEvent {
  const TrainerInitEvent();
}

final class TrainerRequestCourses extends TrainerEvent {
  const TrainerRequestCourses();
}

final class TrainerRequestPending extends TrainerEvent {
  const TrainerRequestPending();
}

final class TrainerRequestSuccess extends TrainerEvent {
  const TrainerRequestSuccess();
}

final class TrainerAddCourseRequest extends TrainerEvent {
  final NewCourse course;
  const TrainerAddCourseRequest({required this.course});
}

final class TrainerAddCourseSuccess extends TrainerEvent {
  const TrainerAddCourseSuccess({required super.message});
}

final class TrainerAddCourseFailed extends TrainerEvent {
  const TrainerAddCourseFailed({required super.message});
}

final class TrainerException extends TrainerEvent {
  const TrainerException({required super.message});
}
