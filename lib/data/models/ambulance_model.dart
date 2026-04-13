// lib/data/models/ambulance_model.dart
import '../../core/constants/app_enums.dart';

class AmbulanceModel {
  final String id;
  final String registrationNumber;
  final String vehicleName;
  final bool hasNicuFacility;
  final List<String> serviceAreas;
  final AmbulanceStatus status;
  final String? agencyName;

  const AmbulanceModel({
    required this.id,
    required this.registrationNumber,
    required this.vehicleName,
    required this.hasNicuFacility,
    required this.serviceAreas,
    required this.status,
    this.agencyName,
  });

  AmbulanceModel copyWith({
    String? registrationNumber,
    String? vehicleName,
    bool? hasNicuFacility,
    List<String>? serviceAreas,
    AmbulanceStatus? status,
  }) {
    return AmbulanceModel(
      id: id,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      vehicleName: vehicleName ?? this.vehicleName,
      hasNicuFacility: hasNicuFacility ?? this.hasNicuFacility,
      serviceAreas: serviceAreas ?? this.serviceAreas,
      status: status ?? this.status,
      agencyName: agencyName,
    );
  }
}
