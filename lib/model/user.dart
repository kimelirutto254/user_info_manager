class User {
  String id;
  String name;
  String email;
  String occupation;
  String bio;
  int v;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.occupation,
    required this.bio,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      occupation: json['occupation'],
      bio: json['bio'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'occupation': occupation,
      'bio': bio,
      '__v': v,
    };
  }
}
