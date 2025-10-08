import 'package:equatable/equatable.dart';

/// Entidade User do domínio
/// Representa um usuário no sistema independente de implementação
class User extends Equatable {
  final String id;
  final String uuid;
  final String name;
  final String username;
  final String email;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.uuid,
    required this.name,
    required this.username,
    required this.email,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Getter para nome de exibição
  String get displayName => name.isNotEmpty ? name : username;

  /// Verificar se o usuário está ativo
  bool get isAccountActive => isActive;

  /// Copiar com novos valores
  User copyWith({
    String? id,
    String? uuid,
    String? name,
    String? username,
    String? email,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
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

  @override
  List<Object> get props => [
    id,
    uuid,
    name,
    username,
    email,
    isActive,
    createdAt,
    updatedAt,
  ];
}
