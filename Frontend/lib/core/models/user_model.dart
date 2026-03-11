class UserModel {
  final int id;
  final String email;
  final String fullName;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        email: json['email'] as String,
        fullName: json['full_name'] as String? ?? '',
      );

  UserModel copyWith({String? fullName, String? email}) => UserModel(
        id: id,
        email: email ?? this.email,
        fullName: fullName ?? this.fullName,
      );
}
