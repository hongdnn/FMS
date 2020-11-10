import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_demo/blocs/response_bloc.dart';
import 'package:my_demo/blocs/response_event.dart';
import 'package:my_demo/blocs/response_state.dart';
import 'package:my_demo/model/myfeedback.dart';
import 'package:my_demo/model/myresponse.dart';
import 'package:my_demo/resources/repository.dart';
import 'package:my_demo/screens/invite_without_gift.dart';

import 'invite.dart';

class Thanks extends StatefulWidget {
  final MyFeedback myFeedback;
  List<MyResponse> listResponse;
  MyResponse myResponse;
  int typeOfResponse;

  Thanks.personalIdea(this.myFeedback, this.myResponse, this.typeOfResponse);

  Thanks(this.myFeedback, this.listResponse, this.typeOfResponse);
  @override
  State<StatefulWidget> createState() => ThanksState();
}

class ThanksState extends State<Thanks> {
  ResponseBloc responseBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    responseBloc = ResponseBloc(repository: Repository());
    if (widget.typeOfResponse == 1) {
      responseBloc.add(SendResponseButtonPressed(listResponse: widget.listResponse));
    }
    else{
      responseBloc.add(SendIdeaButtonPressed(myResponse: widget.myResponse));
    }
    var timer = new Timer(const Duration(seconds: 5), navigateToInvite);
    if ((widget.myFeedback.contentThanks != null &&
            widget.myFeedback.contentThanks.trim().isEmpty) ||
        widget.myFeedback.contentThanks == null) {
      widget.myFeedback.contentThanks =
          "Chân thành cảm ơn những đóng góp của bạn";
    }
  }

  void navigateToInvite() {
    if(widget.myFeedback.description!=null){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => Invite(myFeedback: widget.myFeedback)),
        (route) => false);
    }else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => InviteWithoutGift(myFeedback: widget.myFeedback)),
        (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    AssetImage tichImage = AssetImage('assets/ic_tick.png');
    Image image = Image(
      image: tichImage,
      height: MediaQuery.of(context).size.height * 0.4,
    );
    return   Scaffold(
        body: ListView(children: [
      Padding(
        padding: EdgeInsets.only(left: 0.0, top: 0.0),
        child: Container(
          child: Image.network(
            widget.myFeedback.image,
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          alignment: Alignment.topLeft,
        ),
      ),
      Center(
          child: Column(children: <Widget>[
        image,
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
            child: Text(
              widget.myFeedback.contentThanks,
              style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.height * 0.06,
                fontWeight: FontWeight.bold,
              ),
            )),
      ]))
    ]));
  }
}
