// lib/data/models/referral_model.dart
import '../../core/constants/app_enums.dart';

class ReferralModel {
  final String id;
  final String babyName;
  final String fromHospital;
  final String toHospital;
  final String guardianContact;
  final String? reasonForTransfer;
  final DateTime date;
  final ReferralStatus status;
  final bool isIncoming;

  const ReferralModel({
    required this.id,
    required this.babyName,
    required this.fromHospital,
    required this.toHospital,
    required this.guardianContact,
    this.reasonForTransfer,
    required this.date,
    required this.status,
    required this.isIncoming,
  });

  ReferralModel copyWith({ReferralStatus? status}) {
    return ReferralModel(
      id: id,
      babyName: babyName,
      fromHospital: fromHospital,
      toHospital: toHospital,
      guardianContact: guardianContact,
      reasonForTransfer: reasonForTransfer,
      date: date,
      status: status ?? this.status,
      isIncoming: isIncoming,
    );
  }
}
