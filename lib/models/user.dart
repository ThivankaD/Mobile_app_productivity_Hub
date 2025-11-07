class User {
  int userId;
  String name;
  String email;

  User({required this.userId, required this.name, required this.email});

  @override
  String toString() {
    return 'User: $name ($email)';
  }
}
