class Timetable {
  int timetableId;
  int userId;
  DateTime date;
  DateTime startTime;
  DateTime endTime;
  String details;

  Timetable({
    required this.timetableId,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.details,
  });

  @override
  String toString() {
    return 'Timetable on ${date.toLocal()} from $startTime to $endTime - $details';
  }
}
