import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:my_demo/blocs/response_bloc.dart';
import 'package:my_demo/blocs/response_event.dart';
import 'package:my_demo/blocs/response_state.dart';
import 'package:my_demo/model/myfeedback.dart';
import 'package:my_demo/model/myresponse.dart';
import 'package:my_demo/resources/repository.dart';
import 'package:my_demo/screens/thanks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PersonalIdea extends StatefulWidget {
  final MyFeedback myFeedback;

  PersonalIdea({@required this.myFeedback});
  @override
  State<StatefulWidget> createState() => PersonalIdeaState();
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class PersonalIdeaState extends State<PersonalIdea> {
  TextEditingController ideaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  ScrollController scrollController;
  double _topPadding = 0;
  ResponseBloc responseBloc;
  final GlobalKey<FormState> formEmail = GlobalKey<FormState>();
  Color titleColor = null;
  Color giftColor = null;
  Color buttonColor = null;

  @override
  void initState() {
    super.initState();
    responseBloc = ResponseBloc(repository: Repository());
    scrollController = ScrollController();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        setState(() {
          if (visible) {
            _topPadding = 500.0;
            scrollController.animateTo(MediaQuery.of(context).size.height * 0.3,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          } else {
            _topPadding = 0.0;
            scrollController.animateTo(0,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getColorFromLocal();
    return Scaffold(
            body: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                    controller: scrollController,
                    child: Form(
                        key: formEmail,
                        child: Column(children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.07),
                              child: Center(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Đóng góp ý kiến",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: MediaQuery.of(context).size.height * 0.08,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  alignment: Alignment.topCenter,
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.21,
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.0375),
                                child: TextFormField(
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.035),
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      errorStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03),
                                      labelText: "Địa chỉ email",
                                      labelStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03)),
                                  validator: (value) {
                                    if (value.trim().isEmpty) {
                                      return "Địa chỉ email không được để trống";
                                    } else {
                                      if (!EmailValidator.validate(value)) {
                                        return "Địa chỉ email không hợp lệ";
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                alignment: Alignment.topCenter,
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.03,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.8,
                              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.0375),
                              child: Expanded(
                                  child: TextFormField(
                                maxLines: 12,
                                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.035),
                                controller: ideaController,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03),
                                    labelText: "Ý kiến của bạn",
                                    labelStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03)),
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return "Vui lòng nhập ý kiến của bạn";
                                  }
                                  return null;
                                },
                              )),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.05,
                                  left: MediaQuery.of(context).size.width * 0.1,
                                ),
                                child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: FlatButton(
                                      child: Text(
                                        "Trở lại",
                                        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.05),
                                      ),
                                      color: buttonColor,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(40.0),
                                              bottomLeft:
                                                  Radius.circular(40.0))),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.05,
                                  left: MediaQuery.of(context).size.width * 0.4,
                                ),
                                child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: FlatButton(
                                      child: Text(
                                        "Gửi",
                                        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.05),
                                      ),
                                      color: buttonColor,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(40.0),
                                              bottomRight:
                                                  Radius.circular(40.0))),
                                      onPressed: () {
                                        if (formEmail.currentState.validate()) {
                                          navigateToThanks();
                                        }
                                      },
                                    )),
                              ),
                            ],
                          ),
                          Container(
                            height: _topPadding,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ])))));
  }

  void navigateToThanks() async {
    String email = emailController.text.trim();
    String idea = ideaController.text.trim();
    String now = DateTime.now().toString().replaceFirst(' ', 'T');
    String userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
    SharedPreferences prefs = await SharedPreferences.getInstance();
      MyResponse myResponse = MyResponse.personalIdea(
          responseTime: now,
          responseDetail: idea,
          userAgent: userAgent,
          email: email,
          equipmentId: prefs.getString('EQUIPMENT_ID'));
    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Thanks.personalIdea(widget.myFeedback,myResponse,2)));
  }

  void getColorFromLocal() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      titleColor = prefs.get('TITLE_COLOR') == null ? Color(0xffff6d00) : Color(prefs.get('TITLE_COLOR'));
      giftColor = prefs.get('GIFT_COLOR') == null ? Color(0xffff7043) : Color(prefs.get('GIFT_COLOR'));
      buttonColor = prefs.get('BUTTON_COLOR') == null ? Color(0xffff6d00) : Color(prefs.get('BUTTON_COLOR'));
    });
  }
}
