import 'package:awesome_notifications/awesome_notifications.dart';

class UserNotificationModel{
  static const TITLE='title';
  static const BODY='body';
  static const NOTIFYIMAGE='notifyImage';
  //static const INDEX='index';
  //static const TITLE='title';

  String? _title;
  String? _body;
  String? _notifyImage;
  //int? _index;

  String? get title => _title;
  String? get body => _body;
  String? get notifyImage => _notifyImage;
  //int? get index => _index;

  UserNotificationModel.fromMap(Map data){
    _title=data[TITLE];
    _body=data[BODY];
    _notifyImage=data[NOTIFYIMAGE];
    //_index=data[INDEX];
  }

  Map toMap() => {
    TITLE: _title,
    BODY: _body,
    NOTIFYIMAGE: _notifyImage,
    //INDEX: _index,
  };

}