import 'dart:convert';
import 'dart:developer';

import 'package:ht_web/business/course/usecase/enroll.dart';
import 'package:ht_web/business/course/usecase/search.dart';
import 'package:http/http.dart' as http;
import 'package:ht_web/business/course/model/course.dart';
import 'package:ht_web/business/course/usecase/get_all.dart';
import 'package:ht_web/data/source/course.dart';

final class CourseRepo implements GETAllCourses, Enroll, Search {
  CourseRepo._();

  static final CourseRepo _instance = CourseRepo._();
  static CourseRepo get instance => _instance;

  Map<String, String> get _headers => {
        'content-type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      };

  @override
  Future<List<Course>> getAll() async {
    try {
      Uri uri = Uri.http(
          CourseSource.instance.api, CourseSource.instance.allCoursesEP);

      http.Response response = await http.get(uri, headers: _headers).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw 'Connection Lost',
          );

      if (response.statusCode != 200) throw 'Un Expeted Error';

      final body = jsonDecode(response.body);
      final List<Course> courses = [];

      for (Map<String, dynamic> course in body['allCourses']) {
        courses.add(Course.fromJSON(response: course));
      }

      return courses;
    } catch (e) {
      log('[Course-Repo ERROR]: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> enroll({
    required String uid,
    required String cid,
    required double price,
  }) async {
    try {
      Uri uri =
          Uri.http(CourseSource.instance.api, CourseSource.instance.enrollEP);

      http.Response response = await http
          .post(
            uri,
            headers: _headers,
            body: jsonEncode({"_uid": uid, "_cid": cid, "price": price}),
          )
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw 'Connection Losth');

      final body = jsonDecode(response.body);

      if (response.statusCode != 201) {
        if (response.statusCode == 404) {
          throw body['message'];
        }

        throw 'Unexpected Error';
      }

      return body;
    } catch (e) {
      log('[Course-Repo ERROR] Enrollment: $e');
      rethrow;
    }
  }

  @override
  Future<List<Course>> search({required String request}) async {
    try {
      Uri uri = Uri.http(CourseSource.instance.api,
          CourseSource.instance.serchEP, {"query": request});

      http.Response response = await http.get(uri, headers: _headers).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw 'Connection Losth');

      final body = jsonDecode(response.body);

      if (response.statusCode != 200) throw body['message'];

      final List<Course> courses = [];

      for (Map<String, dynamic> course in body) {
        courses.add(Course.fromJSON(response: course));
      }

      return courses;
    } catch (e) {
      log('[Course-Repo ERROR] SEARCH: $e');
      rethrow;
    }
  }
}
