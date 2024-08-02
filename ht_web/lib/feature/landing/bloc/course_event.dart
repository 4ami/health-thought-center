sealed class CourseEvent {
  final String? message;
  const CourseEvent({this.message});
}

final class CouresInitEvent extends CourseEvent {
  const CouresInitEvent();
}

final class GETAllCoursesRequest extends CourseEvent {
  const GETAllCoursesRequest();
}

final class CourseRequestPending extends CourseEvent {
  const CourseRequestPending();
}

final class CourseRequestSuccess extends CourseEvent {
  const CourseRequestSuccess();
}

final class NewEnroll extends CourseEvent {
  final String uid, cid;
  final double price;
  const NewEnroll({required this.price, required this.uid, required this.cid});
}

final class EnrollSuccess extends CourseEvent {
  const EnrollSuccess({required super.message});
}

final class EnrollFail extends CourseEvent {
  const EnrollFail({required super.message});
}

final class SearchRequestChanged extends CourseEvent {
  final String request;
  const SearchRequestChanged({required this.request});
}

final class SearchSuccess extends CourseEvent {
  const SearchSuccess();
}

final class SearchFailed extends CourseEvent {
  const SearchFailed({required super.message});
}

final class CourseException extends CourseEvent {
  const CourseException({super.message});
}
