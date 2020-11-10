import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:my_demo/blocs/response_bloc.dart';
import 'package:my_demo/model/myfeedback.dart';
import 'package:my_demo/model/myresponse.dart';
import 'package:my_demo/model/question.dart';
import 'package:my_demo/resources/repository.dart';
import 'package:my_demo/screens/boxanswer.dart';
import 'package:my_demo/screens/ratinganswer.dart';
import 'package:my_demo/screens/thanks.dart';
import 'emotionanswer.dart';
import 'multianswer.dart';
import 'oneanswer.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalEmail extends StatefulWidget {
  final MyFeedback myFeedback;
  final List<MyResponse> listResponse;

  PersonalEmail(this.myFeedback, this.listResponse);
  @override
  State<StatefulWidget> createState() => PersonalEmailState();
}

class PersonalEmailState extends State<PersonalEmail> {
  ResponseBloc responseBloc;
  TextEditingController emailController = TextEditingController();
  final formEmail = GlobalKey<FormState>();
  Color titleColor = null;
  Color giftColor = null;
  Color buttonColor = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    responseBloc = ResponseBloc(repository: Repository());
  }

  @override
  Widget build(BuildContext context) {
    getColorFromLocal();
    return Scaffold(
            body: Form(
                key: formEmail,
                child: Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.05),
                    child: Center(
                        child: ListView(children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 0.0, top: 0.0),
                            child: Container(
                              child: Image.network(
                                widget.myFeedback.image,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                              ),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                              left: MediaQuery.of(context).size.width * 0.08,
                              right: MediaQuery.of(context).size.width * 0.005,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: AutoSizeText(
                                widget.myFeedback.title,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.1,
                          ),
                          child: Center(
                            child: Text(
                              "Vui lòng nhập email của bạn",
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.06),
                          child: Center(
                              child: FittedBox(
                                  child: Container(
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.04),
                              controller: emailController,
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(fontSize: 25.0),
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.04)),
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
                            height: MediaQuery.of(context).size.height * 0.16,
                            width: MediaQuery.of(context).size.width * 0.6,
                          )))),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.18,
                              left: MediaQuery.of(context).size.width * 0.05),
                          child: Row(children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.13,
                                width:
                                    MediaQuery.of(context).size.width * 0.15625,
                                child: FlatButton(
                                  child: Text(
                                    "Trở lại",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  color: buttonColor,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40.0),
                                          bottomLeft: Radius.circular(40.0))),
                                  onPressed: () {
                                    navigateBack();
                                  },
                                ),
                              ),
                            ),
                            Expanded(flex: 2, child: Center()),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.13,
                                  width: MediaQuery.of(context).size.width *
                                      0.15625,
                                  child: FlatButton(
                                    child: Text(
                                      "Gửi",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          fontWeight: FontWeight.bold),
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
                            )
                          ]))
                    ])))));
  }

  void navigateBack() {
    widget.listResponse.removeLast();
    Navigator.pop(context);
  }

  void navigateToQuestion(int sequence) {
    Question question = widget.myFeedback.questions.elementAt(sequence);
    int typeOfSurvey = question.typeOfSurvey;
    if (typeOfSurvey == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EmotionAnswer(
                  widget.myFeedback, sequence, widget.listResponse)));
    }
    if (typeOfSurvey == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RatingAnswer(
                  widget.myFeedback, sequence, widget.listResponse)));
    }
    if (typeOfSurvey == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MultiAnswer(
                  widget.myFeedback, sequence, widget.listResponse)));
    }
    if (typeOfSurvey == 4) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OneAnswer(widget.myFeedback, sequence, widget.listResponse)));
    }
    if (typeOfSurvey == 5) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BoxAnswer(widget.myFeedback, sequence, widget.listResponse)));
    }
  }

  void navigateToThanks() async {
    String email = emailController.text.trim();
    String userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
    if (email != "") {
      for (int i = 0; i < widget.listResponse.length; i++) {
        widget.listResponse[i].email = email;
        widget.listResponse[i].userAgent = userAgent;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Thanks(widget.myFeedback, widget.listResponse,1)));
    }
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
