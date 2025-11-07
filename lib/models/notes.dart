class Note {
  int noteId;
  int userId;
  String title;
  String description;

  Note({
    required this.noteId,
    required this.userId,
    required this.title,
    required this.description,
  });

  @override
  String toString() {
    return 'Note: $title - $description';
  }
}
