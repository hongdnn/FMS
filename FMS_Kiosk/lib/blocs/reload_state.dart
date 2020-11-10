import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:my_demo/model/myfeedback.dart';
import 'package:my_demo/viewmodel/login_viewmodel.dart';

abstract class ReloadState extends Equatable {
  const ReloadState();

  @override
  List<Object> get props => [];
}

class ReloadInitial extends ReloadState {}

class ReloadInProgress extends ReloadState {}

class ReloadSuccess extends ReloadState {
  final MyFeedback myFeedback;

  const ReloadSuccess({@required this.myFeedback});
}

class ReloadSuccessWithoutFeedback extends ReloadState {}

class ReloadFailure extends ReloadState {
  final String error;

  const ReloadFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class LogoutSuccess extends ReloadState {
  final bool success;

  const LogoutSuccess({@required this.success});
}

class LogoutFailure extends ReloadState {
  final String error;

  const LogoutFailure({@required this.error});

  @override
  List<Object> get props => [error];
}