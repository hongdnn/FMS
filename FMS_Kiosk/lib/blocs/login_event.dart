
import 'package:my_demo/viewmodel/login_viewmodel.dart';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final LoginViewModel loginViewModel;

  const LoginButtonPressed({
    @required this.loginViewModel,
  });

  @override
  List<Object> get props => [loginViewModel];

}