class User {
  final String name;
  final String lastName;
  final int age;
  final String email;

  User({
    required this.name,
    required this.lastName,
    required this.age,
    required this.email,
  });

factory User.fromJson(Map<String, dynamic> json) {
  return User(
    name: json['name'],
    lastName: json['last_name'],
    age: json['age'],
    email: json['auth']['email'],
    );
  }
}