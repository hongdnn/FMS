import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:my_demo/model/myresponse.dart';

abstract class ResponseEvent extends Equatable {
  const ResponseEvent();
}

class SendResponseButtonPressed extends ResponseEvent {
  final List<MyResponse> listResponse;

  const SendResponseButtonPressed({
    @required this.listResponse
  });

  @override
  List<Object> get props => [listResponse];

}

class SendIdeaButtonPressed extends ResponseEvent{
  final MyResponse myResponse;

  const SendIdeaButtonPressed({
    @required this.myResponse
  });
  @override
  List<Object> get props => [myResponse];
  
}