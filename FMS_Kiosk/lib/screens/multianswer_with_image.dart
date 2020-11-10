import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:my_demo/model/myfeedback.dart';
import 'package:my_demo/model/myimage.dart';
import 'package:my_demo/model/myresponse.dart';
import 'package:my_demo/model/question.dart';
import 'package:my_demo/screens/boxanswer.dart';
import 'package:my_demo/screens/oneanswer.dart';
import 'package:my_demo/screens/personal_email.dart';
import 'package:my_demo/screens/emotionanswer.dart';
import 'package:my_demo/screens/ratinganswer.dart';
import 'package:my_demo/screens/ratinganswer_with_image.dart';
import 'package:my_demo/screens/thanks.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'emotionanswer_with_image.dart';
import 'multianswer.dart';
import 'oneanswer_with_image.dart';

class MultiAnswerWithImage extends StatefulWidget {
  final MyFeedback myFeedback;
  final int currentQuestion;
  final List<MyResponse> listResponse;

  MultiAnswerWithImage(
      this.myFeedback, this.currentQuestion, this.listResponse);
  @override
  State<StatefulWidget> createState() => MultiAnswerWithImageState();
}

class MultiAnswerWithImageState extends State<MultiAnswerWithImage> {
  bool checkedValue0 = false;
  bool isChecked = false;
  bool checkedValue1 = false;
  bool checkedValue2 = false;
  bool checkedValue3 = false;
  String choice = "";
  List<dynamic> listChoice = List<dynamic>();
  Color titleColor = null;
  Color giftColor = null;
  Color buttonColor = null;
  @override
  Widget build(BuildContext context) {
    getColorFromLocal();
    String questionSequence = (widget.currentQuestion + 1).toString() +
        '/' +
        widget.myFeedback.questions.length.toString();
    Question question = widget.myFeedback.questions[widget.currentQuestion];
    String answerOption = question.answerOption;
    List<String> answers = answerOption.split("//");
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.05),
            child: Center(
                child: ListView(children: <Widget>[
              Row(children: [
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
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02,
                        left: MediaQuery.of(context).size.width * 0.08,
                        right: MediaQuery.of(context).size.width * 0.005),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
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
                    )),
              ]),
              Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.01),
                  child: Row(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.0),
                      child: Image.network(
                        question.image.imageLink,
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.4,
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ListView(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.04,
                                  left:
                                      MediaQuery.of(context).size.width * 0.04),
                              child: Center(
                                  child: Text(
                                question.contentQuestion,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))),
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01,
                                left: MediaQuery.of(context).size.width * 0.01),
                            child: CheckboxGroup(
                              orientation: GroupedButtonsOrientation.VERTICAL,
                              onSelected: (List selected) => setState(() {
                                print(selected.toString());
                                listChoice = new List<dynamic>();
                                for (int i = 0; i < selected.length; i++) {
                                  listChoice.add(selected[i]);
                                }
                              }),
                              labels: answers,
                              labelStyle: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                              itemBuilder: (Checkbox cb, Text txt, int i) {
                                return Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.003),
                                  child: Row(
                                    children: <Widget>[
                                      Transform.scale(scale: 1.5, child: cb),
                                      txt,
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ])),
                  ])),
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Row(children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.13,
                        width: MediaQuery.of(context).size.width*0.15625,
                        child: FlatButton(
                          child: Text(
                            "Trở lại",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * 0.05,
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
                    Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            questionSequence,
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height * 0.05,
                                 fontWeight: FontWeight.bold),
                          ),
                        )),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.13,
                          width: MediaQuery.of(context).size.width * 0.15625,
                          child: FlatButton(
                            child: Text(
                              "Kế tiếp",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height * 0.05,
                                   fontWeight: FontWeight.bold),
                            ),
                            color: buttonColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(40.0),
                                    bottomRight: Radius.circular(40.0))),
                            onPressed: () {
                              navigateToAnotherQuestion();
                            },
                          )),
                    )
                  ]))
            ]))));
  }

  void onClickedCheckbox() {
    setState(() {});
  }

  void navigateToAnotherQuestion() async {
    if (listChoice.isNotEmpty) {
      for (int i = 0; i < listChoice.length; i++) {
        choice += listChoice[i] + "//";
      }
      String now = DateTime.now().toString().replaceFirst(' ', 'T');
      SharedPreferences prefs = await SharedPreferences.getInstance();

      MyResponse response = MyResponse.withParams(
          now,
          widget.myFeedback.questions[widget.currentQuestion].questionId,
          choice,
          "userAgent",
          null,
          prefs.getString('EQUIPMENT_ID'));
      widget.listResponse.add(response);
      if (widget.currentQuestion + 1 < widget.myFeedback.questions.length) {
        int nextSequence = widget.currentQuestion + 1;
        navigateToQuestion(nextSequence);
      } else {
        if(widget.myFeedback.description!=null){
        bool result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PersonalEmail(widget.myFeedback, widget.listResponse)));
        }else{
          Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Thanks(widget.myFeedback, widget.listResponse,1)));
        }
      }
    }
  }

  void navigateToQuestion(int sequence) {
    Question question = widget.myFeedback.questions.elementAt(sequence);
    int typeOfSurvey = question.typeOfSurvey;
    MyImage image = question.image;
    if (typeOfSurvey == 1) {
      if (image != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmotionAnswerWithImage(
                    widget.myFeedback, sequence, widget.listResponse)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmotionAnswer(
                    widget.myFeedback, sequence, widget.listResponse)));
      }
    }
    if (typeOfSurvey == 2) {
      if (image != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RatingAnswerWithImage(
                    widget.myFeedback, sequence, widget.listResponse)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RatingAnswer(
                    widget.myFeedback, sequence, widget.listResponse)));
      }
    }
    if (typeOfSurvey == 3) {
      if (image != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultiAnswerWithImage(
                    widget.myFeedback, sequence, widget.listResponse)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultiAnswer(
                    widget.myFeedback, sequence, widget.listResponse)));
      }
    }
    if (typeOfSurvey == 4) {
      if (image != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OneAnswerWithImage(
                    widget.myFeedback, sequence, widget.listResponse)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OneAnswer(
                    widget.myFeedback, sequence, widget.listResponse)));
      }
    }
    if (typeOfSurvey == 5) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BoxAnswer(widget.myFeedback, sequence, widget.listResponse)));
    }
  }

  void navigateBack() {
    if (widget.currentQuestion > 0) {
      widget.listResponse.removeLast();
    }
    Navigator.pop(context);
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
