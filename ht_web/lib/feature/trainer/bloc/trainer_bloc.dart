import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/business/course/model/course.dart';
import 'package:ht_web/business/trainer/repository/trainer_exception.dart';
import 'package:ht_web/business/trainer/repository/trainer_repo.dart';
import 'package:ht_web/conf/shared/secure_storage.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_event.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_state.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final class TrainerBLOC extends Bloc<TrainerEvent, TrainerState> {
  final TrainerRepository repo = TrainerRepository.instance;
  TrainerBLOC() : super(const TrainerState()) {
    on<TrainerRequestCourses>((event, emit) async {
      try {
        emit(state.copyWith(event: const TrainerRequestPending()));

        if (state.id.isEmpty) {
          final cred = await SecureStorage.instance.read();

          final String id = JwtDecoder.decode(cred['token']!)['_id'];

          emit(state.copyWith(id: id));
        }

        final List<Course> courses = await repo.getCourses(id: state.id);
        emit(
          state.copyWith(
            courses: courses,
            event: const TrainerRequestSuccess(),
          ),
        );
      } on TrainerHTTPException catch (e) {
        log('[Trainer-BLOC ERROR]: ${e.reason}');
        emit(state.copyWith(event: TrainerException(message: e.reason)));
      } catch (e) {
        log('[Trainer-BLOC ERROR]: $e');
        emit(
          state.copyWith(
            event: const TrainerAddCourseFailed(
              message: 'Something Goes Wrong!',
            ),
          ),
        );
      }
    });

    on<TrainerAddCourseRequest>((event, emit) async {
      try {
        emit(state.copyWith(event: const TrainerRequestPending()));

        if (state.id.isEmpty) {
          final cred = await SecureStorage.instance.read();

          final String id = JwtDecoder.decode(cred['token']!)['_id'];

          emit(state.copyWith(id: id));
        }

        final String message =
            await repo.add(course: event.course, id: state.id);

        emit(state.copyWith(event: TrainerAddCourseSuccess(message: message)));
      } on TrainerHTTPException catch (e) {
        log('[Trainer-BLOC ERROR]: ${e.reason}');
        emit(
          state.copyWith(event: TrainerAddCourseFailed(message: e.reason)),
        );
      } catch (e) {
        log('[Trainer-BLOC ERROR]: $e');
        emit(
          state.copyWith(
            event: const TrainerAddCourseFailed(
              message: 'Something Goes Wrong!',
            ),
          ),
        );
      }
    });
  }
}
