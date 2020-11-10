import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:my_demo/blocs/response_event.dart';
import 'package:my_demo/blocs/response_state.dart';
import 'package:my_demo/resources/repository.dart';

class ResponseBloc extends Bloc<ResponseEvent, ResponseState> {
  final Repository repository;

  ResponseBloc({
    @required this.repository,
  }) : assert(repository != null);

  ResponseState get initialState => ResponseInitial();

  @override
  Stream<ResponseState> mapEventToState(ResponseEvent event) async* {
    if (event is SendResponseButtonPressed) {
      yield (ResponseProgress());

      try {
        final result = await repository.sendResponse(event.listResponse);
        if (result == 0) {
          if (event.listResponse[0].email != null) {
            final sendEmailResult =
                await repository.sendGiftToMail(event.listResponse[0].email);
            if (sendEmailResult) {
              print("Send email success");
            } else {
              print("Send email fail");
            }
          }
          yield ResponseSuccess();
        } else {
          yield ResponseFailure(error: result.toString());
        }
      } catch (error) {
        yield ResponseFailure(error: error.toString());
      }
    }

    if (event is SendIdeaButtonPressed) {
      yield (ResponseProgress());

      try {
        final result = await repository.sendPersonalIdea(event.myResponse);
        if (result == 0) {
          yield ResponseSuccess();
        } else {
          yield ResponseFailure(error: result.toString());
        }
      } catch (error) {
        yield ResponseFailure(error: error.toString());
      }
    }
  }
}
