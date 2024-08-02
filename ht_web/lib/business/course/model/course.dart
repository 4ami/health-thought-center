final class Course {
  final String id, name, description, mode, dueDate;
  final int duration;
  final double price;
  const Course({
    required this.id,
    required this.name,
    this.description = 'NA',
    required this.mode,
    required this.dueDate,
    required this.duration,
    required this.price,
  });

  factory Course.fromJSON({required Map<String, dynamic> response}) {
    return Course(
      id: response['_id'],
      name: response['name'],
      description: response['description'],
      mode: response['mode'],
      dueDate: response['due_date'],
      duration: response['duration'],
      price: double.parse(response['price']),
    );
  }
}
