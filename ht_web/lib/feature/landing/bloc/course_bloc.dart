import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/business/course/model/course.dart';
import 'package:ht_web/business/course/repository/course_exception.dart';
import 'package:ht_web/business/course/repository/course_repo.dart';
import 'package:ht_web/feature/landing/bloc/course_event.dart';
import 'package:ht_web/feature/landing/bloc/course_state.dart';

final class CourseBLOC extends Bloc<CourseEvent, CourseState> {
  final CourseRepo repo = CourseRepo.instance;
  CourseBLOC() : super(const CourseState()) {
    on<GETAllCoursesRequest>((event, emit) async {
      try {
        emit(state.copyWith(event: const CourseRequestPending()));

        final List<Course> all = await repo.getAll();

        emit(state.copyWith(all: all, event: const CourseRequestSuccess()));
      } on CourseHTTPException catch (e) {
        log('[Course BLOC Error]: ${e.reason}');
        emit(state.copyWith(event: CourseException(message: e.reason)));
      } catch (e) {
        log('[Course BLOC Error]: $e');
        emit(state.copyWith(
            event: const SearchFailed(message: 'Something Goes Wrong!')));
      }
    });

    on<NewEnroll>((event, emit) async {
      try {
        emit(state.copyWith(event: const CourseRequestPending()));

        final Map<String, dynamic> response = await repo.enroll(
            uid: event.uid, cid: event.cid, price: event.price);

        emit(
          state.copyWith(
            event: EnrollSuccess(message: response['message'].toString()),
          ),
        );
      } on CourseHTTPException catch (e) {
        log('[Course BLOC Error]: ${e.reason}');
        emit(state.copyWith(event: EnrollFail(message: e.reason)));
      } catch (e) {
        log('[Course BLOC Error]: $e');
        emit(state.copyWith(
            event: const SearchFailed(message: 'Something Goes Wrong!')));
      }
    });

    on<SearchRequestChanged>((event, emit) async {
      try {
        emit(state.copyWith(
            request: event.request, event: const CourseRequestPending()));

        final courses = await repo.search(request: event.request);

        emit(state.copyWith(event: const SearchSuccess(), response: courses));
      } on CourseHTTPException catch (e) {
        log('[Course BLOC Error]: SEARCH\n ${e.reason}');
        emit(state.copyWith(event: SearchFailed(message: e.reason)));
      } catch (e) {
        log('[Course BLOC Error]: SEARCH\n $e');
        emit(state.copyWith(
            event: const SearchFailed(message: 'Something Goes Wrong!')));
      }
    });
  }
}
