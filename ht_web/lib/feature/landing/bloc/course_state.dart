import 'package:ht_web/business/course/model/course.dart';
import 'package:ht_web/feature/landing/bloc/course_event.dart';

final class CourseState {
  final String request;
  final List<Course> response;
  final List<Course> all;
  final CourseEvent event;

  const CourseState({
    this.all = const [],
    this.event = const CouresInitEvent(),
    this.request = '',
    this.response = const [],
  });

  CourseState copyWith({
    String? request,
    List<Course>? all,
    List<Course>? response,
    CourseEvent? event,
  }) {
    return CourseState(
      request: request ?? this.request,
      all: all ?? this.all,
      response: response ?? this.response,
      event: event ?? this.event,
    );
  }
}
