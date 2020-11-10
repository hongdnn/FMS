import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:my_demo/model/myfeedback.dart';
import 'package:my_demo/viewmodel/login_viewmodel.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginViewModel loginViewModel;
  final MyFeedback myFeedback;

  const LoginSuccess({@required this.myFeedback, @required this.loginViewModel});
}
class LoginSuccessWithoutFeedback extends LoginState{}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({@required this.error});

  @override
  List<Object> get props => [error];
}