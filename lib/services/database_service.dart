import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudyml_app2/models/course_details.dart';

class DatabaseService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Stream<List<CourseDetails>> get courseDetails {
    return _fireStore.collection('courses').snapshots().map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (documentSnapshot) => CourseDetails(
                  amountPayable: documentSnapshot.data()['Amount Payable'],
                  courseDocumentId: documentSnapshot.id,
                  courseId: documentSnapshot.data()['id'],
                  courseImageUrl: documentSnapshot.data()['image_url'],
                  courseLanguage: documentSnapshot.data()['language'],
                  // courseMentors: documentSnapshot.data()['mentors'],
                  coursePrice: documentSnapshot.data()['Course Price'],
                  createdBy: documentSnapshot.data()['created by'],
                  discount: documentSnapshot.data()['Discount'],
                  isItComboCourse: documentSnapshot.data()['combo'],
                  courses: documentSnapshot.data()['courses'] ?? [''],
                  courseName: documentSnapshot.data()['name'],
                  // isItPaidCourse: documentSnapshot.data()['paid'],
                  numOfVideos:
                      documentSnapshot.data()['videosCount'].toString(),
                  curriculum: documentSnapshot.data()['curriculum'],
                  courseDescription: documentSnapshot.data()['description'],
                ),
              )
              .toList(),
        );
  }
}
