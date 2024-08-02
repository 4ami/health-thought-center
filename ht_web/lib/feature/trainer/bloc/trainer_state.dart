import 'package:ht_web/business/course/model/course.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_event.dart';

final class TrainerState {
  final String id;
  final List<Course> courses;
  final TrainerEvent event;

  const TrainerState({
    this.id = '',
    this.courses = const [],
    this.event = const TrainerInitEvent(),
  });

  TrainerState copyWith({
    String? id,
    TrainerEvent? event,
    List<Course>? courses,
  }) {
    return TrainerState(
      id: id ?? this.id,
      event: event ?? this.event,
      courses: courses ?? this.courses,
    );
  }
}
