import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_demo/blocs/reload_bloc.dart';
import 'package:my_demo/blocs/reload_event.dart';
import 'package:my_demo/blocs/reload_state.dart';
import 'package:my_demo/main.dart';
import 'package:my_demo/model/message.dart';
import 'package:my_demo/model/myfeedback.dart';
import 'package:my_demo/model/myimage.dart';
import 'package:my_demo/model/myresponse.dart';
import 'package:my_demo/model/question.dart';
import 'package:my_demo/resources/repository.dart';
import 'package:my_demo/screens/emotionanswer.dart';
import 'package:my_demo/screens/multianswer.dart';
import 'package:my_demo/screens/oneanswer_with_image.dart';
import 'package:my_demo/screens/personal_idea.dart';
import 'package:my_demo/screens/oneanswer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_demo/screens/ratinganswer.dart';
import 'package:my_demo/screens/ratinganswer_with_image.dart';
import 'package:my_demo/viewmodel/login_viewmodel.dart';
import 'package:my_demo/screens/emptyFeedback.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'boxanswer.dart';
import 'emotionanswer_with_image.dart';
import 'invite_without_gift.dart';
import 'multianswer_with_image.dart';

class Invite extends StatefulWidget {
  MyFeedback myFeedback;
  final LoginViewModel loginViewModel;
  Invite({@required this.myFeedback, this.loginViewModel});
  @override
  State<StatefulWidget> createState() => InviteState();
}

class InviteState extends State<Invite> {
  ReloadBloc reloadBloc;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];
  Color titleColor = null;
  Color giftColor = null;
  Color buttonColor = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reloadBloc = ReloadBloc(repository: Repository());

    getColorFromLocal();

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
                  loginViewModel: widget.loginViewModel, isLogout: false));
              break;
            }
          case "ACTION_SIGNOUT":
            {
              print("logout ne");
              reloadBloc.add(ReloadEventStarted(
                  loginViewModel: widget.loginViewModel, isLogout: true));
              break;
            }
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReloadBloc, ReloadState>(
        bloc: reloadBloc,
        listener: (context, state) {
          if (state is ReloadFailure) {
            print("Reload fail");
          } else if (state is ReloadSuccess) {
            MyFeedback myFeedback = state.myFeedback;
            if (myFeedback != null) {
              if (myFeedback.description == null) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InviteWithoutGift(
                              myFeedback: myFeedback,
                            )),
                    (route) => false);
              } else {
                setState(() {
                  widget.myFeedback = myFeedback;
                });
              }
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
            floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              child: Icon(Icons.color_lens),
              onPressed: () {
                print('Clicked');
                showColorPicker();
              },
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child: Container(
                        child: Image.network(
                          widget.myFeedback.image,
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                        alignment: Alignment.topLeft,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.07,
                          right: MediaQuery.of(context).size.width * 0.02),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: AutoSizeText(
                          widget.myFeedback.title,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: MediaQuery.of(context).size.height * 0.1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                      left: MediaQuery.of(context).size.width * 0.2),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.02),
                            child: Container(
                                width:
                                    MediaQuery.of(context).size.height * 0.25,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                alignment: Alignment.centerLeft,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new ExactAssetImage(
                                            'assets/gift.gif')))),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.02,
                                right:
                                    MediaQuery.of(context).size.width * 0.02),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: AutoSizeText(
                                  widget.myFeedback.description,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.clip,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.067,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(
                                MediaQuery.of(context).size.height * 0.15),
                            bottomLeft: Radius.circular(
                                MediaQuery.of(context).size.height * 0.15)),
                        color: giftColor,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: FlatButton(
                        child: Text(
                          "Tham gia ngay",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.061),
                        ),
                        color: buttonColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0))),
                        onPressed: () {
                          navigateToQuestion(0);
                        },
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.07,
                    right: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: FlatButton(
                            child: Text(
                              "Ý kiến cá nhân",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.046),
                            ),
                            color: buttonColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PersonalIdea(
                                            myFeedback: widget.myFeedback,
                                          )));
                            },
                          ))),
                )
              ],
            )));
  }

  void navigateToQuestion(int sequence) {
    List<MyResponse> listResponse = List<MyResponse>();
    Question question = widget.myFeedback.questions.elementAt(sequence);
    int typeOfSurvey = question.typeOfSurvey;
    MyImage image = question.image;
    if (typeOfSurvey == 1) {
      if (image != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmotionAnswerWithImage(
                    widget.myFeedback, sequence, listResponse)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EmotionAnswer(widget.myFeedback, sequence, listResponse)));
      }
    }
    if (typeOfSurvey == 2) {
      if (image != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RatingAnswerWithImage(
                    widget.myFeedback, sequence, listResponse)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RatingAnswer(widget.myFeedback, sequence, listResponse)));
      }
    }
    if (typeOfSurvey == 3) {
      if (image != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultiAnswerWithImage(
                    widget.myFeedback, sequence, listResponse)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MultiAnswer(widget.myFeedback, sequence, listResponse)));
      }
    }
    if (typeOfSurvey == 4) {
      if (image != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OneAnswerWithImage(
                    widget.myFeedback, sequence, listResponse)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OneAnswer(widget.myFeedback, sequence, listResponse)));
      }
    }
    if (typeOfSurvey == 5) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BoxAnswer(widget.myFeedback, sequence, listResponse)));
    }
  }

  void getColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  void showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
            title: const Text(
              'Màu chủ đề',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: getListColorOption());
      },
    );
  }

  List<FMSColor> listColors = [
    new FMSColor.withParams("Cam", 0xffff6d00, 0xffff7043, 0xffff6d00),
    new FMSColor.withParams("Lục", 0xff4caf50, 0xff66bb6a, 0xff4caf50),
    new FMSColor.withParams("Dương", 0xff1976d2, 0xff2196f3, 0xff1976d2),
  ];

  List<SimpleDialogOption> getListColorOption() {
    List<SimpleDialogOption> list = [];
    listColors.forEach((element) {
      list.add(SimpleDialogOption(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(element.titleColor),
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: 50,
              height: 50,
            ),
            Container(
              width: 20,
            ),
            Text(
              element.colorName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onPressed: () {
          chooseColor(element.colorName);
        },
      ));
    });

    return list;
  }

  void getColorFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      titleColor = prefs.get('TITLE_COLOR') == null
          ? Color(0xffff6d00)
          : Color(prefs.get('TITLE_COLOR'));
      giftColor = prefs.get('GIFT_COLOR') == null
          ? Color(0xffff7043)
          : Color(prefs.get('GIFT_COLOR'));
      buttonColor = prefs.get('BUTTON_COLOR') == null
          ? Color(0xffff6d00)
          : Color(prefs.get('BUTTON_COLOR'));
    });
  }

  void chooseColor(String colorName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    listColors.forEach((element) {
      if (colorName == element.colorName) {
        setState(() {
          titleColor = Color(element.titleColor);
          giftColor = Color(element.giftColor);
          buttonColor = Color(element.buttonColor);
        });
        prefs.setInt('TITLE_COLOR', element.titleColor);
        prefs.setInt('GIFT_COLOR', element.giftColor);
        prefs.setInt('BUTTON_COLOR', element.buttonColor);
      }
    });

    Navigator.pop(context);
  }
}

class FMSColor {
  String colorName;
  int titleColor;
  int giftColor;
  int buttonColor;

  FMSColor({this.colorName, this.titleColor, this.giftColor, this.buttonColor});

  FMSColor.withParams(
      String colorName, int titleColor, int giftColor, int buttonColor) {
    this.colorName = colorName;
    this.titleColor = titleColor;
    this.giftColor = giftColor;
    this.buttonColor = buttonColor;
  }
}
