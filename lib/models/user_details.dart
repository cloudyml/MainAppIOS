class UserDetails {
  String userName;
  String userId;
  String emailId;
  String mentors;
  String mobilenumber;
  List<String?> paidCoursesId;
  Map<String, Map> payInPartsDetails;
  String role;

  UserDetails({
    required this.userName,
    required this.userId,
    required this.emailId,
    required this.mentors,
    required this.mobilenumber,
    required this.paidCoursesId,
    required this.payInPartsDetails,
    required this.role,
  });
}
