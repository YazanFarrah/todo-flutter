class User {
  final String name;
  final String email;
  final String password;
  final String? token;
  final List<dynamic>? todo;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.token,
    this.todo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      todo: json['todo'],
    );
  }
}
