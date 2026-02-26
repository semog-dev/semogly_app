class Account {
  final String publicId;
  final String name;
  final String email;

  Account({required this.publicId, required this.name, required this.email});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      publicId: json['publicId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Account copyWith({String? name, String? email}) {
    return Account(
      publicId: publicId,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
