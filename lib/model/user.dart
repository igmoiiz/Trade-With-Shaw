class User {
  final String id;
  final String email;
  final bool isPremium;

  User({required this.id, required this.email, required this.isPremium});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      isPremium: json['isPremium'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'isPremium': isPremium,
  };
}
