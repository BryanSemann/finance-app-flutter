class User {
  final String uuid;
  final String name;
  final String username;
  final String email;
  final int statusCode;
  final DateTime updatedAt;
  final DateTime createdAt;

  User({
    required this.uuid,
    required this.name,
    required this.username,
    required this.email,
    required this.statusCode,
    required this.updatedAt,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uuid: map['uuid'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      statusCode: map['statusCode'] ?? 0,
      updatedAt: DateTime.parse(
        map['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'username': username,
      'email': email,
      'statusCode': statusCode,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(String source) {
    return User.fromMap(Map<String, dynamic>.from(<String, dynamic>{}));
  }

  String toJson() => toMap().toString();

  User copyWith({
    String? uuid,
    String? name,
    String? username,
    String? email,
    int? statusCode,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return User(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      statusCode: statusCode ?? this.statusCode,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'User(uuid: $uuid, name: $name, username: $username, email: $email, statusCode: $statusCode)';
  }

  // Helpers
  bool get isActive => statusCode == 1;
  String get displayName => name.isNotEmpty ? name : username;
}
