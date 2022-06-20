import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserModel{
  static const ID='id';
  static const NAME='name';
  static const MOBILE='mobilenumber';
  static const EMAIL='email';
  static const IMAGE='image';

  //Question mark is for that the _id can be null also
  String? _id;
  String? _mobile;
  String? _email;
  String? _name;
  String? _image;

  String? get id=> _id;
  String? get mobile=> _mobile;
  String? get email=> _email;
  String? get name=> _name;
  String? get image=> _image;

  UserModel.fromSnapShot(DocumentSnapshot<Map<String,dynamic>> snapshot){
    _name=(snapshot.data()![NAME]=='')?'Enter name':snapshot.data()![NAME];
    _email=(snapshot.data()![EMAIL]=='')?'Enter email':snapshot.data()![EMAIL];
    _mobile=(snapshot.data()![MOBILE]=='')?'Enter mobile':snapshot.data()![MOBILE];
    _id=snapshot.data()![ID];
    _image=(snapshot.data()![IMAGE]=='')?'https://stratosphere.co.in/img/user.jpg':snapshot.data()![IMAGE];
  }

}

// class UserDetails {
//   String userName;
//   String userId;
//   String emailId;
//   String mentors;
//   String mobilenumber;
//   List<String?> paidCoursesId;
//   Map<String, Map> payInPartsDetails;
//   String role;

//   UserDetails({
//     required this.userName,
//     required this.userId,
//     required this.emailId,
//     required this.mentors,
//     required this.mobilenumber,
//     required this.paidCoursesId,
//     required this.payInPartsDetails,
//     required this.role,
//   });
// }