// lib/data/models/user_model.dart
import '../../core/constants/app_enums.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? organizationName;
  final String? phone;
  final String? address;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.organizationName,
    this.phone,
    this.address,
  });

  UserModel copyWith({
    String? name,
    String? phone,
    String? address,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role,
      organizationName: organizationName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}
