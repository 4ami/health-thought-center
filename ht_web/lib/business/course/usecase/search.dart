import 'package:ht_web/business/course/model/course.dart';

interface class Search {
  Future<List<Course>> search({required String request}) =>
      throw UnimplementedError();
}
