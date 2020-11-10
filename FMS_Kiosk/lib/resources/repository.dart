import 'dart:async';
import 'package:my_demo/model/loginresult.dart';
import 'package:my_demo/model/myresponse.dart';
import 'package:my_demo/viewmodel/login_viewmodel.dart';

import 'myfeedback_api_provider.dart';
import 'package:my_demo/model/myfeedback.dart';

class Repository {

  final myFeedbackApiProvider = MyFeedbackApiProvider();

  Future<LoginResult> login(LoginViewModel loginViewModel) => myFeedbackApiProvider.loginEquipment(loginViewModel);

  Future<int> sendResponse(List<MyResponse> listResponse) => myFeedbackApiProvider.sendResponse(listResponse);

  Future<bool> sendFCMToken(String fcmToken) => myFeedbackApiProvider.sendFCMToken(fcmToken);

  Future<MyFeedback> getFeedback() => myFeedbackApiProvider.getFeedback();

  Future<bool> logout() => myFeedbackApiProvider.logout();

  Future<bool> sendGiftToMail(String email) => myFeedbackApiProvider.sendGiftToMail(email);

  Future<int> sendPersonalIdea(MyResponse myResponse) => myFeedbackApiProvider.sendPersonalIdea(myResponse);

}