// lib/data/models/nicu_bed_model.dart
import '../../core/constants/app_enums.dart';

class NicuBedModel {
  final String id;
  final String bedCode;
  final BedStatus status;
  final String? babyName;
  final String? guardianName;
  final String? guardianRelation;
  final String? guardianPhone;
  final DateTime? admittedDate;

  const NicuBedModel({
    required this.id,
    required this.bedCode,
    required this.status,
    this.babyName,
    this.guardianName,
    this.guardianRelation,
    this.guardianPhone,
    this.admittedDate,
  });

  NicuBedModel copyWith({
    BedStatus? status,
    String? babyName,
    String? guardianName,
    String? guardianRelation,
    String? guardianPhone,
    DateTime? admittedDate,
  }) {
    return NicuBedModel(
      id: id,
      bedCode: bedCode,
      status: status ?? this.status,
      babyName: babyName,
      guardianName: guardianName,
      guardianRelation: guardianRelation,
      guardianPhone: guardianPhone,
      admittedDate: admittedDate,
    );
  }
}
