import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ResponseState extends Equatable {
  const ResponseState();

  @override
  List<Object> get props => [];
}

class ResponseInitial extends ResponseState {}

class ResponseProgress extends ResponseState {}

class ResponseSuccess extends ResponseState {
  const ResponseSuccess();
}

class ResponseFailure extends ResponseState {
  final String error;

  const ResponseFailure({@required this.error});

  @override
  List<Object> get props => [error];
}