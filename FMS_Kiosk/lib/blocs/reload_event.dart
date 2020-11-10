
import 'package:my_demo/viewmodel/login_viewmodel.dart';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ReloadEvent extends Equatable {
  const ReloadEvent();
}

class ReloadEventStarted extends ReloadEvent {
  final LoginViewModel loginViewModel;
  final bool isLogout;

  const ReloadEventStarted({
    @required this.loginViewModel,
    @required this.isLogout
  });

  @override
  List<Object> get props => [loginViewModel];

}