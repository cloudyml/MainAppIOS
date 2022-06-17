import 'package:cloudyml_app2/Services/UserServices.dart';
import 'package:cloudyml_app2/models/UserModel.dart';
import 'package:cloudyml_app2/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Status{Uninitialized,Authenticated,Authenticating,Unauthenticated}

class UserProvider with ChangeNotifier{
  UserServices _userServices=UserServices();
  FirebaseAuth? _auth;
  User? _user;
  UserModel? _userModel;

  User? get user=> _user;
  UserModel? get userModel=> _userModel;

  UserProvider.initialize():
      _auth=FirebaseAuth.instance{
          _auth?.authStateChanges().listen(_onStateChangedme);
  }


  Future<void> _onStateChangedme(User? user) async{
    if(user!=null){
      _user=user;
      _userModel=await _userServices.getUserById(user!.uid);
      // splash();
    }else{
      // splash();
    }
      notifyListeners();
  }

  Future<void> reloadUserModel()async{
    _userModel = await _userServices.getUserById(_auth!.currentUser!.uid);
    notifyListeners();
  }
}