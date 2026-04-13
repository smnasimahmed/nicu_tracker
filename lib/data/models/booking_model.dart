// lib/data/models/booking_model.dart
import '../../core/constants/app_enums.dart';

class BookingModel {
  final String id;
  final String patientName;
  final String phone;
  final BookingType type;
  final BookingStatus status;
  final String targetName;
  final DateTime date;
  final String? notes;

  const BookingModel({
    required this.id,
    required this.patientName,
    required this.phone,
    required this.type,
    required this.status,
    required this.targetName,
    required this.date,
    this.notes,
  });
}
