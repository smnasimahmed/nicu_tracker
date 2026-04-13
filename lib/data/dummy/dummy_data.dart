// lib/data/dummy/dummy_data.dart
import '../models/ambulance_model.dart';
import '../models/booking_model.dart';
import '../models/hospital_model.dart';
import '../models/nicu_bed_model.dart';
import '../models/referral_model.dart';
import '../models/user_model.dart';
import '../../core/constants/app_enums.dart';

class DummyData {
  DummyData._();

  // ─── Users ───────────────────────────────────────────────────────────────

  static const UserModel hospitalUser = UserModel(
    id: 'h001',
    name: 'Dr. Rahman',
    email: 'admin@hospital.com',
    role: UserRole.hospital,
    organizationName: 'Dhaka Medical College Hospital',
    phone: '01711000001',
  );

  static const UserModel ambulanceUser = UserModel(
    id: 'a001',
    name: 'Rapid Care',
    email: 'admin@ambulance.com',
    role: UserRole.ambulance,
    organizationName: 'Rapid Care Ambulance Services',
    phone: '01711000002',
  );

  static const UserModel patientUser = UserModel(
    id: 'p001',
    name: 'Md. Karim',
    email: 'karim@gmail.com',
    role: UserRole.patient,
    phone: '01711000003',
    address: 'Mirpur-10, Dhaka',
  );

  // ─── NICU Beds ────────────────────────────────────────────────────────────

  static List<NicuBedModel> nicuBeds = [
    NicuBedModel(
      id: 'bed1',
      bedCode: 'NICU-01',
      status: BedStatus.occupied,
      babyName: 'Baby Hasan',
      guardianName: 'Fatima Begum',
      guardianRelation: 'Mother',
      guardianPhone: '01712345678',
      admittedDate: DateTime(2026, 3, 10),
    ),
    NicuBedModel(
      id: 'bed2',
      bedCode: 'NICU-02',
      status: BedStatus.available,
    ),
    NicuBedModel(
      id: 'bed3',
      bedCode: 'NICU-03',
      status: BedStatus.occupied,
      babyName: 'Baby Akter',
      guardianName: 'Karim Uddin',
      guardianRelation: 'Father',
      guardianPhone: '01898765432',
      admittedDate: DateTime(2026, 3, 12),
    ),
    NicuBedModel(
      id: 'bed4',
      bedCode: 'NICU-04',
      status: BedStatus.available,
    ),
    NicuBedModel(
      id: 'bed5',
      bedCode: 'NICU-05',
      status: BedStatus.inTransit,
    ),
    NicuBedModel(
      id: 'bed6',
      bedCode: 'NICU-06',
      status: BedStatus.occupied,
      babyName: 'Baby Noor',
      guardianName: 'Salma Khatun',
      guardianRelation: 'Mother',
      guardianPhone: '01556781234',
      admittedDate: DateTime(2026, 3, 8),
    ),
    NicuBedModel(
      id: 'bed7',
      bedCode: 'NICU-07',
      status: BedStatus.available,
    ),
    NicuBedModel(
      id: 'bed8',
      bedCode: 'NICU-08',
      status: BedStatus.occupied,
      babyName: 'Baby Islam',
      guardianName: 'Rafiq Islam',
      guardianRelation: 'Father',
      guardianPhone: '01634567890',
      admittedDate: DateTime(2026, 3, 14),
    ),
  ];

  // ─── Hospitals ────────────────────────────────────────────────────────────

  static const List<HospitalModel> hospitals = [
    HospitalModel(
      id: 'hosp1',
      name: 'City Hospital',
      address: 'Elephant Road, Dhaka',
      totalBeds: 10,
      availableBeds: 3,
      phone: '01711100001',
      distanceKm: 2.5,
    ),
    HospitalModel(
      id: 'hosp2',
      name: 'Lab-Aid Hospital',
      address: 'Dhanmondi, Dhaka',
      totalBeds: 8,
      availableBeds: 1,
      phone: '01711100002',
      distanceKm: 4.1,
    ),
    HospitalModel(
      id: 'hosp3',
      name: 'Square Hospital',
      address: 'West Panthapath, Dhaka',
      totalBeds: 12,
      availableBeds: 5,
      phone: '01711100003',
      distanceKm: 5.8,
    ),
    HospitalModel(
      id: 'hosp4',
      name: 'United Hospital',
      address: 'Gulshan, Dhaka',
      totalBeds: 6,
      availableBeds: 0,
      phone: '01711100004',
      distanceKm: 7.2,
    ),
    HospitalModel(
      id: 'hosp5',
      name: 'Evercare Hospital',
      address: 'Bashundhara, Dhaka',
      totalBeds: 10,
      availableBeds: 2,
      phone: '01711100005',
      distanceKm: 9.4,
    ),
  ];

  // ─── Referrals ────────────────────────────────────────────────────────────

  static List<ReferralModel> outgoingReferrals = [
    ReferralModel(
      id: 'ref1',
      babyName: 'Baby Khan',
      fromHospital: 'Dhaka Medical College Hospital',
      toHospital: 'City Hospital',
      guardianContact: 'Mst. Amina - 01711222333',
      reasonForTransfer: 'Need specialist care',
      date: DateTime(2026, 3, 13),
      status: ReferralStatus.pending,
      isIncoming: false,
    ),
    ReferralModel(
      id: 'ref2',
      babyName: 'Baby Chowdhury',
      fromHospital: 'Dhaka Medical College Hospital',
      toHospital: 'Square Hospital',
      guardianContact: 'Md. Salim - 01711222444',
      date: DateTime(2026, 3, 9),
      status: ReferralStatus.completed,
      isIncoming: false,
    ),
  ];

  static List<ReferralModel> incomingReferrals = [
    ReferralModel(
      id: 'ref3',
      babyName: 'Baby Mia',
      fromHospital: 'Lab-Aid Hospital',
      toHospital: 'Dhaka Medical College Hospital',
      guardianContact: 'Rehana Begum - 01799887766',
      reasonForTransfer: 'Premature birth, needs NICU',
      date: DateTime(2026, 3, 9),
      status: ReferralStatus.confirmed,
      isIncoming: true,
    ),
    ReferralModel(
      id: 'ref4',
      babyName: 'Baby Rana',
      fromHospital: 'City Hospital',
      toHospital: 'Dhaka Medical College Hospital',
      guardianContact: 'Abdul Rana - 01688991122',
      reasonForTransfer: 'Respiratory distress',
      date: DateTime(2026, 3, 11),
      status: ReferralStatus.pending,
      isIncoming: true,
    ),
  ];

  // ─── Ambulances ───────────────────────────────────────────────────────────

  static List<AmbulanceModel> ambulances = [
    AmbulanceModel(
      id: 'amb1',
      registrationNumber: 'Dhaka Metro-Cha-11-2233',
      vehicleName: 'Toyota Hiace',
      hasNicuFacility: true,
      serviceAreas: ['Gazipur', 'Dhaka'],
      status: AmbulanceStatus.active,
      agencyName: 'Rapid Care Ambulance Services',
    ),
    AmbulanceModel(
      id: 'amb2',
      registrationNumber: 'Dhaka Metro-Ka-22-4455',
      vehicleName: 'Mitsubishi L300',
      hasNicuFacility: false,
      serviceAreas: ['Mymensingh', 'Dhaka'],
      status: AmbulanceStatus.active,
      agencyName: 'Rapid Care Ambulance Services',
    ),
    AmbulanceModel(
      id: 'amb3',
      registrationNumber: 'Dhaka Metro-Ga-33-6677',
      vehicleName: 'Ford Transit',
      hasNicuFacility: false,
      serviceAreas: ['Narayanganj'],
      status: AmbulanceStatus.inactive,
      agencyName: 'Rapid Care Ambulance Services',
    ),
    AmbulanceModel(
      id: 'amb4',
      registrationNumber: 'Dhaka Metro-Gha-44-8899',
      vehicleName: 'Mercedes Sprinter',
      hasNicuFacility: true,
      serviceAreas: ['Tangail', 'Dhaka'],
      status: AmbulanceStatus.active,
      agencyName: 'Rapid Care Ambulance Services',
    ),
    AmbulanceModel(
      id: 'amb5',
      registrationNumber: 'Dhaka Metro-Uma-55-1122',
      vehicleName: 'Tata Winger',
      hasNicuFacility: false,
      serviceAreas: ['Dhaka'],
      status: AmbulanceStatus.inactive,
      agencyName: 'Rapid Care Ambulance Services',
    ),
  ];

  // ─── Public Ambulances (for Patient view) ─────────────────────────────────

  static const List<AmbulanceModel> publicAmbulances = [
    AmbulanceModel(
      id: 'pub_amb1',
      registrationNumber: 'Dhaka Metro-Cha-11-2233',
      vehicleName: 'Toyota Hiace',
      hasNicuFacility: true,
      serviceAreas: ['Dhaka', 'Gazipur'],
      status: AmbulanceStatus.active,
      agencyName: 'Rapid Care Ambulance Services',
    ),
    AmbulanceModel(
      id: 'pub_amb2',
      registrationNumber: 'Dhaka Metro-Ka-22-4455',
      vehicleName: 'Mitsubishi L300',
      hasNicuFacility: false,
      serviceAreas: ['Dhaka', 'Mymensingh'],
      status: AmbulanceStatus.active,
      agencyName: 'Rapid Care Ambulance Services',
    ),
    AmbulanceModel(
      id: 'pub_amb3',
      registrationNumber: 'Dhaka Metro-Gha-44-8899',
      vehicleName: 'Mercedes Sprinter',
      hasNicuFacility: true,
      serviceAreas: ['Dhaka', 'Tangail'],
      status: AmbulanceStatus.active,
      agencyName: 'City Ambulance Network',
    ),
    AmbulanceModel(
      id: 'pub_amb4',
      registrationNumber: 'Dhaka Metro-Ja-55-3344',
      vehicleName: 'Nissan Urvan',
      hasNicuFacility: false,
      serviceAreas: ['Dhaka', 'Narayanganj'],
      status: AmbulanceStatus.active,
      agencyName: 'Metro Ambulance Service',
    ),
  ];

  // ─── Patient Bookings ─────────────────────────────────────────────────────

  static List<BookingModel> patientBookings = [
    BookingModel(
      id: 'bk1',
      patientName: 'Md. Karim',
      phone: '01711000003',
      type: BookingType.nicuBed,
      status: BookingStatus.pending,
      targetName: 'City Hospital',
      date: DateTime(2026, 4, 10),
      notes: 'Premature baby',
    ),
    BookingModel(
      id: 'bk2',
      patientName: 'Md. Karim',
      phone: '01711000003',
      type: BookingType.ambulance,
      status: BookingStatus.confirmed,
      targetName: 'Rapid Care Ambulance Services',
      date: DateTime(2026, 3, 20),
    ),
  ];

  // ─── Service Areas ────────────────────────────────────────────────────────

  static const List<String> serviceAreas = [
    'Dhaka',
    'Gazipur',
    'Tangail',
    'Narayanganj',
    'Narsingdi',
    'Mymensingh',
    'Manikganj',
    'Munshiganj',
    'Faridpur',
    'Kishoreganj',
  ];
}
