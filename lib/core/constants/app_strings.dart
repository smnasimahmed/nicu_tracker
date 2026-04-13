// lib/core/constants/app_strings.dart

class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'NICU Tracker';

  // Auth
  static const String selectRole = 'Select Your Role';
  static const String loginAsHospital = 'Hospital Admin';
  static const String loginAsAmbulance = 'Ambulance Service';
  static const String loginAsPatient = 'Patient / Guardian';
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String enterEmail = 'Enter your email';
  static const String enterPassword = 'Enter your password';
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String invalidEmail = 'Enter a valid email';
  static const String passwordTooShort = 'Password must be at least 6 characters';

  // Hospital Navigation
  static const String dashboard = 'Dashboard';
  static const String nicuBeds = 'NICU Beds';
  static const String referPatient = 'Refer Patient';
  static const String referHistory = 'Refer History';
  static const String incomingReferrals = 'Incoming Referrals';

  // Hospital Dashboard
  static const String totalBeds = 'Total Beds';
  static const String availableBeds = 'Available';
  static const String occupiedBeds = 'Occupied';
  static const String incomingReferralsCount = 'Incoming Referrals';
  static const String bedTracking = 'Bed Tracking';
  static const String nicuBedsManagement = 'NICU Beds Management';
  static const String hospitalAdmin = 'Hospital Admin';

  // Bed Status
  static const String statusOccupied = 'Occupied';
  static const String statusAvailable = 'Available';
  static const String statusInTransit = 'In Transit';
  static const String scanToAdmit = 'Scan to Admit';
  static const String patientIncoming = 'Patient incoming...';

  // Bed Actions
  static const String admit = 'Admit';
  static const String discharge = 'Discharge';
  static const String confirmDischarge = 'Confirm Discharge';
  static const String confirmDischargeMessage =
      'Are you sure you want to discharge this patient? This action cannot be undone.';
  static const String confirmOccupyBed = 'CONFIRM & OCCUPY BED';
  static const String readyForAdmission = 'Ready for Admission';

  // Admit Form
  static const String babyName = 'Baby Name';
  static const String enterBabyName = 'Enter baby name';
  static const String relation = 'Relation';
  static const String contactName = 'Contact Name';
  static const String enterGuardianName = 'Enter guardian name';
  static const String phoneNo = 'Phone No';
  static const String phoneHint = '01XXXXXXXXX';
  static const String skip = 'SKIP';

  // Refer Patient
  static const String patientDetails = 'Patient Details';
  static const String currentGuardianContact = 'Current Guardian Contact';
  static const String guardianNameOrPhone = 'Guardian name or phone';
  static const String reasonForTransfer = 'Reason for Transfer';
  static const String describeReason = 'Describe the reason...';
  static const String destinationSelection = 'Destination Selection';
  static const String selectDestinationHospital = 'Select Destination Hospital';
  static const String chooseHospital = 'Choose a hospital';
  static const String sendReferralRequest = 'Send Referral Request';
  static const String guardianContactRequired = 'Guardian contact is required';
  static const String destinationRequired = 'Please select a destination hospital';
  static const String referralSentSuccess = 'Referral request sent successfully!';

  // Referral History
  static const String referralHistory = 'Referral History';
  static const String baby = 'Baby';
  static const String from = 'From';
  static const String to = 'To';
  static const String guardianLabel = 'Guardian';
  static const String date = 'Date';
  static const String status = 'Status';
  static const String outgoingReferrals = 'Outgoing Referrals';
  static const String noReferralHistory = 'No referral history found';
  static const String noIncomingReferrals = 'No incoming referrals';
  static const String pending = 'Pending';
  static const String completed = 'Completed';
  static const String confirm = 'Confirm';
  static const String cancelled = 'Cancelled';
  static const String updateStatus = 'Update Status';
  static const String confirmReferral = 'Confirm';
  static const String completeReferral = 'Complete';
  static const String cancelReferral = 'Cancel';
  static const String bedAdmitSuccess = 'Patient admitted successfully!';
  static const String bedDischargeSuccess = 'Patient discharged successfully!';

  // Ambulance Navigation
  static const String addAmbulance = 'Add Ambulance';
  static const String myProfile = 'My Profile';

  // Ambulance Dashboard
  static const String totalRegistered = 'Total Registered';
  static const String activeAmbulances = 'Active Ambulances';
  static const String inactiveMaintenance = 'Inactive / Maintenance';
  static const String ambulancesInFleet = 'Ambulances in your fleet';
  static const String currentlyOnDuty = 'Currently on-duty';
  static const String currentlyOffline = 'Currently offline';
  static const String quickStatusOverview = 'Quick Status Overview';
  static const String active = 'Active';
  static const String inactive = 'Inactive';

  // Ambulance Form
  static const String myFleet = 'My Fleet';
  static const String addNewAmbulance = '+ Add New Ambulance';
  static const String registrationNumber = 'Registration Number';
  static const String vehicleName = 'Vehicle Name';
  static const String nicuIcuAvailable = 'NICU/ICU Available';
  static const String nicuIcuDesc = 'Does this vehicle have NICU/ICU facilities?';
  static const String serviceArea = 'Service Area (Catchment)';
  static const String vehiclePhotos = 'Vehicle Photos (max 3)';
  static const String cancel = 'Cancel';
  static const String saveAmbulanceDetails = 'Save Ambulance Details';
  static const String editAmbulance = 'Edit Ambulance';
  static const String updateAmbulanceDesc = 'Update the details of your ambulance.';
  static const String addAmbulanceDesc = 'Add a new ambulance to your fleet.';
  static const String registrationHint = 'e.g., Dhaka Metro-Cha-11-2233';
  static const String vehicleNameHint = 'e.g., Toyota Hiace';
  static const String ambulanceSavedSuccess = 'Ambulance details saved!';
  static const String registrationRequired = 'Registration number is required';
  static const String vehicleNameRequired = 'Vehicle name is required';

  // Patient
  static const String patientPortal = 'Patient Portal';
  static const String bookNicuBed = 'Book NICU Bed';
  static const String bookAmbulance = 'Book Ambulance';
  static const String myBookings = 'My Bookings';
  static const String profile = 'Profile';
  static const String bedsAvailable = 'Beds Available';
  static const String noBedsAvailable = 'No Beds Available';
  static const String requestBed = 'Request Bed';
  static const String nicuEquipped = 'NICU Equipped';
  static const String bookNow = 'Book Now';
  static const String filterNearby = 'Nearby';
  static const String allAreas = 'All Areas';
  static const String fullName = 'Full Name';
  static const String phoneNumber = 'Phone Number';
  static const String address = 'Address';
  static const String saveProfile = 'Save Profile';
  static const String enterFullName = 'Enter your full name';
  static const String enterPhone = 'Enter phone number';
  static const String enterAddress = 'Enter your address';
  static const String register = 'Register';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String bookingSuccess = 'Booking request sent successfully!';
  static const String profileSaved = 'Profile saved successfully!';
  static const String nameRequired = 'Name is required';
  static const String phoneRequired = 'Phone is required';

  // Connectivity
  static const String noInternet = 'No Internet Connection';
  static const String noInternetMessage =
      'This app requires an active internet connection. Please check your network settings and try again.';
  static const String retry = 'Retry';

  // General
  static const String ok = 'OK';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String save = 'Save';
  static const String edit = 'Edit';
  static const String close = 'Close';
  static const String loading = 'Loading...';
  static const String fieldRequired = 'This field is required';
  static const String welcomeTo = 'Welcome to';
}
