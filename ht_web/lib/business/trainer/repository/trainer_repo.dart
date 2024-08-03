import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ht_web/business/course/model/course.dart';
import 'package:ht_web/business/trainer/repository/trainer_exception.dart';
import 'package:ht_web/business/trainer/usecase/get_trainer_courses.dart';
import 'package:ht_web/business/trainer/usecase/new_course.dart';
import 'package:ht_web/data/model/new_course.dart';
import 'package:ht_web/data/source/trainer.dart';
import 'package:http/http.dart' as http;

final class TrainerRepository implements GETTrainerCourses, AddNew {
  TrainerRepository._();
  static final TrainerRepository _instance = TrainerRepository._();

  static TrainerRepository get instance => _instance;

  Map<String, String> get _headers {
    return {
      'content-type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
      'x-api-key': dotenv.get('TRAINER_KEY'),
    };
  }

  @override
  Future<List<Course>> getCourses({required String id}) async {
    try {
      Uri uri = Uri.http(
        TrainerSource.instance.api,
        '${TrainerSource.instance.trainerCoursesEP}/$id',
      );

      http.Response response = await http.get(uri, headers: _headers).timeout(
          const Duration(seconds: 10),
          onTimeout: () =>
              throw const TrainerHTTPException(reason: 'Connection Lost'));

      final body = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw TrainerHTTPException(reason: body['message']);
      }

      final List<Course> courses = [];
      for (Map<String, dynamic> course in body) {
        courses.add(Course.fromJSON(response: course['COURSE']));
      }

      return courses;
    } catch (e) {
      log('[Trainer-Repository ERROR] - GET Trainer Courses $e');
      rethrow;
    }
  }

  @override
  Future<String> add({required NewCourse course, required String id}) async {
    try {
      Uri uri = Uri.http(TrainerSource.instance.api,
          '${TrainerSource.instance.trainerCreateCourseEP}/$id');

      http.Response response = await http
          .post(uri, headers: _headers, body: course.toJSON())
          .timeout(const Duration(seconds: 10),
              onTimeout: () =>
                  throw const TrainerHTTPException(reason: 'Connection Lost'));

      final body = jsonDecode(response.body);

      if (response.statusCode != 201) {
        throw TrainerHTTPException(reason: body['message']);
      }

      return body['message'];
    } catch (e) {
      log('[Trainer-Repository ERROR] - New Trainer Courses $e');
      rethrow;
    }
  }
}
