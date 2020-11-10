// import 'package:my_demo/resources/repository.dart';
// import 'package:my_demo/viewmodel/login_viewmodel.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:my_demo/model/myfeedback.dart';

// class MyFeedbackBloc {
//   final _repository = Repository();
//   final _myFeedbackFetcher = PublishSubject<MyFeedback>();

//   Stream<MyFeedback> get myFeedback => _myFeedbackFetcher.stream;

//   getFeedback(LoginViewModel loginViewModel) async {
//     MyFeedback myFeedback = await _repository.getFeedback(loginViewModel);
//     _myFeedbackFetcher.sink.add(myFeedback);
//   }

//   dispose() {
//     _myFeedbackFetcher.close();
//   }
// }

// final bloc = MyFeedbackBloc();

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:my_demo/model/loginresult.dart';
import 'package:my_demo/resources/repository.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Repository repository;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  LoginBloc({
    @required this.repository,
  })  : assert(repository != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    var fcmToken = "";
    _firebaseMessaging.getToken().then((token) {
      fcmToken = token;
      print("Token: $token");
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (event is LoginButtonPressed) {
      yield LoginInProgress();
      try {
        if (!event.loginViewModel.isIsAlreadyLogin()){
          var result = await repository.login(event.loginViewModel);
          if(result != null){
            LoginResult loginResult = result;
            if (result.status == 1) {
              yield LoginFailure(error:"Tài khoản đã được đăng nhập");
            } else if (result.status == 2) {
              yield LoginFailure(error:"Đăng nhập thất bại");
            } else if (result.status == 3) {
              yield LoginFailure(error:"Lỗi kết nối");
            } else {

              if (prefs.getString('ACCESS_TOKEN') != null){
                prefs.remove('ACCESS_TOKEN');
              }
              prefs.setString('ACCESS_TOKEN', result.accessToken);
              print("Token: " + prefs.getString('ACCESS_TOKEN'));

              if (prefs.getString('EQUIPMENT_ID') != null){
                prefs.remove('EQUIPMENT_ID');
              }
              prefs.setString('EQUIPMENT_ID', event.loginViewModel.equipmentCode);

              //Send FCM token to server
              var fcmResult = await repository.sendFCMToken(fcmToken);
              if (fcmResult) {
                print("Send FCM token success");
              } else {
                print("Send FCM token fail");
              }

              //Get feedback
              var feedbackResult = await repository.getFeedback();
              if (feedbackResult != null){
                print("Get feedback success");
                yield LoginSuccess(myFeedback: feedbackResult, loginViewModel: event.loginViewModel,);
              } else {
                print("Get feedback fail");
                yield LoginSuccessWithoutFeedback();
              }
            }
          }
        }
        else {
          if (prefs.getString('ACCESS_TOKEN') != null) {
            var feedbackResult = await repository.getFeedback();
            if (feedbackResult != null){
              print("Get feedback success");
              yield LoginSuccess(myFeedback: feedbackResult, loginViewModel: event.loginViewModel,);
            } else {
              yield LoginSuccessWithoutFeedback();
            }
          }
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}