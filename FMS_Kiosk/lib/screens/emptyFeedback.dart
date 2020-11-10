import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_demo/model/myfeedback.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_demo/blocs/reload_bloc.dart';
import 'package:my_demo/blocs/reload_event.dart';
import 'package:my_demo/blocs/reload_state.dart';
import 'package:my_demo/resources/repository.dart';
import 'package:my_demo/viewmodel/login_viewmodel.dart';

import '../main.dart';
import 'invite.dart';

class EmptyFeedback extends StatefulWidget {

  EmptyFeedback();
  @override
  State<StatefulWidget> createState() => EmptyFeedbackState();
}

class EmptyFeedbackState extends State<EmptyFeedback> {
  ReloadBloc reloadBloc;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final LoginViewModel loginViewModel = LoginViewModel();

  @override
  void initState() {
    super.initState();

    reloadBloc = ReloadBloc(repository: Repository());

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        String action = message['data']['action'];
        print("action: $action");
        final notification = message['notification'];
        switch (action) {
          case "ACTION_RELOAD":
            {
              print("reload ne");
              reloadBloc.add(ReloadEventStarted(
                  loginViewModel: loginViewModel, isLogout: false));
              break;
            }
          case "ACTION_SIGNOUT":
            {
              print("logout ne");
              reloadBloc.add(ReloadEventStarted(
                  loginViewModel: loginViewModel, isLogout: true));
              break;
            }
        }
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    AssetImage tichImage = AssetImage('assets/emptyFeedback.png');
    Image image = Image(
      image: tichImage,
      height: MediaQuery.of(context).size.height * 0.5,
    );
    return BlocListener<ReloadBloc, ReloadState>(
        bloc: reloadBloc,
        listener: (context, state) {
          if (state is ReloadFailure) {
            print("Reload fail");
          } else if (state is ReloadSuccess) {
            MyFeedback myFeedback = state.myFeedback;
            if (myFeedback != null) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => Invite(
                      myFeedback: myFeedback,
                      loginViewModel: loginViewModel)), (route) => false);
            }
          } else if (state is LogoutFailure) {
          } else if (state is LogoutSuccess) {
            print("nhay qua login ne");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
                (route) => false);
          } else if (state is ReloadSuccessWithoutFeedback) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => EmptyFeedback()),
                (route) => false);
          }
        },
        child: Scaffold(
            body: ListView(children: [
          Center(
              child: Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15),
                child: image),
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.08),
                child: Text(
                  "Khảo sát đang được cập nhật",
                  style: TextStyle(
                    color: Color.fromRGBO(36, 76, 140, 1.0),
                    fontSize: MediaQuery.of(context).size.height * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ]))
        ])));
  }
}
