import 'dart:convert';

final class NewCourse {
  final String mode, name, description;
  final int duration;
  final double price;
  final String dueDate;

  const NewCourse({
    required this.name,
    this.description = '',
    required this.duration,
    required this.mode,
    required this.price,
    required this.dueDate,
  });

  String toJSON() {
    return jsonEncode({
      "name": name,
      "description": description,
      "duration": duration,
      "mode": mode,
      "price": price,
      "due_date": dueDate,
    });
  }
}
