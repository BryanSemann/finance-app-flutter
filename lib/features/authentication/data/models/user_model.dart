import '../../domain/entities/user.dart';

/// Model que estende a entidade User para serialização
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.uuid,
    required super.name,
    required super.username,
    required super.email,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Criar a partir da entidade
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      uuid: user.uuid,
      name: user.name,
      username: user.username,
      email: user.email,
      isActive: user.isActive,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  /// Criar a partir do JSON da API
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      uuid: json['uuid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isActive: json['status_code'] == 1 || json['is_active'] == true,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  /// Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'username': username,
      'email': email,
      'is_active': isActive,
      'status_code': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Criar a partir do JSON do cache local
  factory UserModel.fromCache(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      uuid: json['uuid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isActive: json['is_active'] == true,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  /// Converter para cache
  Map<String, dynamic> toCacheJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'username': username,
      'email': email,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Copiar com novos valores (override para retornar UserModel)
  @override
  UserModel copyWith({
    String? id,
    String? uuid,
    String? name,
    String? username,
    String? email,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
