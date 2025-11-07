class Reminder {
  int reminderId;
  int userId;
  String title;
  String description;
  String repeatOption;

  Reminder({
    required this.reminderId,
    required this.userId,
    required this.title,
    required this.description,
    required this.repeatOption,
  });

  @override
  String toString() {
    return 'Reminder: $title - $description (Repeat: $repeatOption)';
  }
}
