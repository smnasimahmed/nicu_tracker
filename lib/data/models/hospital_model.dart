// lib/data/models/hospital_model.dart

class HospitalModel {
  final String id;
  final String name;
  final String address;
  final int totalBeds;
  final int availableBeds;
  final String? phone;
  final double? distanceKm;
  final String? district;
  final String? division;

  const HospitalModel({
    required this.id,
    required this.name,
    required this.address,
    required this.totalBeds,
    required this.availableBeds,
    this.phone,
    this.distanceKm,
    this.district,
    this.division,
  });

  int get occupiedBeds => totalBeds - availableBeds;
  bool get hasAvailableBeds => availableBeds > 0;
}
