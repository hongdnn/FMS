import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:my_demo/blocs/reload_event.dart';
import 'package:my_demo/blocs/reload_state.dart';
import 'package:my_demo/resources/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_state.dart';

class ReloadBloc extends Bloc<ReloadEvent, ReloadState> {
  final Repository repository;

  ReloadBloc({
    @required this.repository,
  })  : assert(repository != null);

  ReloadState get initialState => ReloadInitial();

  @override
  Stream<ReloadState> mapEventToState(ReloadEvent event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (event is ReloadEventStarted) {
      yield ReloadInProgress();

      try {
        if (event.isLogout) {
          final result = await repository.logout();
          if (result) {
            if (prefs.getString('ACCESS_TOKEN') != null){
              prefs.remove('ACCESS_TOKEN');
            }
            if (prefs.getString('EQUIPMENT_ID') != null){
              prefs.remove('EQUIPMENT_ID');
            }
            yield LogoutSuccess(success: true);
          }
          else {
            yield LogoutFailure(error: "Đăng xuất thất bại");
          }
        }
        else {
          final result = await repository.getFeedback();
          if(result==null){
            yield ReloadSuccessWithoutFeedback();
          }
          else{
            yield ReloadSuccess(myFeedback: result);
          }
        }
      } catch (error) {
        yield ReloadFailure(error:"Cập nhật thất bại");
      }
    }
  }
}