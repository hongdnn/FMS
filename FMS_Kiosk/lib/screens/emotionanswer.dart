import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_demo/model/myfeedback.dart';
import 'package:my_demo/model/myimage.dart';
import 'package:my_demo/model/question.dart';
import 'package:my_demo/model/myresponse.dart';
import 'package:my_demo/screens/boxanswer.dart';
import 'package:my_demo/screens/personal_email.dart';
import 'package:my_demo/screens/ratinganswer.dart';
import 'package:my_demo/screens/ratinganswer_with_image.dart';
import 'package:my_demo/screens/thanks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'emotionanswer_with_image.dart';
import 'multianswer_with_image.dart';
import 'oneanswer.dart';
import 'multianswer.dart';
import 'oneanswer_with_image.dart';

class EmotionAnswer extends StatefulWidget {
  final MyFeedback myFeedback;
  final int currentQuestion;
  final List<MyResponse> listResponse;

  EmotionAnswer(this.myFeedback, this.currentQuestion, this.listResponse);
  @override
  State<StatefulWidget> createState() => EmotionAnswerState();
}

class EmotionAnswerState extends State<EmotionAnswer> {
  String choice = "0";
  Color madColor=Colors.black;
  Color confusedColor=Colors.black;
  Color smilingColor=Colors.black;
  Color happyColor=Colors.black;
  Color inloveColor=Colors.black;
  Color titleColor = null;
  Color giftColor = null;
  Color buttonColor = null;
  
  @override
  Widget build(BuildContext context) {
    getColorFromLocal();
    double ratio= MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    String questionSequence = (widget.currentQuestion+1).toString() +
        '/' +
        widget.myFeedback.questions.length.toString();
    Question question = widget.myFeedback.questions[widget.currentQuestion];
    return Scaffold(
        body: Padding(
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
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02,
                   left: MediaQuery.of(context).size.width * 0.08, right: MediaQuery.of(context).size.width * 0.005, ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: AutoSizeText(
                        widget.myFeedback.title,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        style: TextStyle(
                          color: titleColor,
                          fontSize:  MediaQuery.of(context).size.height * 0.1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
//                  alignment: Alignment.topRight,
                    ),
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.width * 0.01,),
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ListView(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.04,
                                left: MediaQuery.of(context).size.width * 0.04),
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
                                top: MediaQuery.of(context).size.height * 0.05,
                                left:
                                    MediaQuery.of(context).size.width * 0.03),
                            child: Row(children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.02),
                                  child: Column(children: <Widget>[ InkWell(
                                    onTap: () {
                                      choice = "1";
                                      setState(() {
                                         madColor=Colors.yellow;
                                         confusedColor=Colors.black;
                                         smilingColor=Colors.black;
                                         happyColor=Colors.black;
                                         inloveColor=Colors.black;
                                      });
                                    },
                                    child: Ink.image(
                                      image: AssetImage('assets/mad.png'),
                                      width: MediaQuery.of(context).size.width * 0.15,
                                      height: MediaQuery.of(context).size.height*0.15*ratio,
                                    ),
                                  ),
                                  Text("Thất vọng",
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: madColor
                                      ))
                                  ]),),
                              Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.02),
                                  child: Column(children: <Widget>[ InkWell(
                                    onTap: () {
                                      choice = "2";
                                      setState(() {
                                         madColor=Colors.black;
                                         confusedColor=Colors.yellow;
                                         smilingColor=Colors.black;
                                         happyColor=Colors.black;
                                         inloveColor=Colors.black;
                                      });
                                    },
                                    child: Ink.image(
                                      image: AssetImage('assets/confused.png'),
                                      width: MediaQuery.of(context).size.width * 0.15,
                                      height: MediaQuery.of(context).size.height*0.15*ratio,
                                    ),
                                  ),Text("Tạm ổn",
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: confusedColor
                                      ))
                                  ]),),
                              Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.02),
                                  child: Column(children: <Widget>[ InkWell(
                                    onTap: () {
                                      choice = "3";
                                     setState(() {
                                         madColor=Colors.black;
                                         confusedColor=Colors.black;
                                         smilingColor=Colors.yellow;
                                         happyColor=Colors.black;
                                         inloveColor=Colors.black;
                                      });
                                    },
                                    child: Ink.image(
                                      image: AssetImage('assets/smiling.png'),
                                      width: MediaQuery.of(context).size.width * 0.15,
                                      height: MediaQuery.of(context).size.height*0.15*ratio,
                                    ),
                                  ),Text("Tốt",
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: smilingColor
                                      ))
                                  ]),),
                              Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.02),
                                  child: Column(children: <Widget>[ InkWell(
                                    onTap: () {
                                      choice = "4";
                                      setState(() {
                                         madColor=Colors.black;
                                         confusedColor=Colors.black;
                                         smilingColor=Colors.black;
                                         happyColor=Colors.yellow;
                                         inloveColor=Colors.black;
                                      });
                                    },
                                    child: Ink.image(
                                      image: AssetImage('assets/happy.png'),
                                      width: MediaQuery.of(context).size.width * 0.15,
                                      height: MediaQuery.of(context).size.height*0.15*ratio,
                                    ),
                                  ),Text("Tuyệt vời",
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: happyColor
                                      ))
                                  ]),),
                              Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.02),
                                  child: Column(children: <Widget>[ InkWell(
                                    onTap: () {
                                      choice = "5";
                                      setState(() {
                                         madColor=Colors.black;
                                         confusedColor=Colors.black;
                                         smilingColor=Colors.black;
                                         happyColor=Colors.black;
                                         inloveColor=Colors.yellow;
                                      });
                                    },
                                    child: Ink.image(
                                      image: AssetImage('assets/in-love.png'),
                                      width: MediaQuery.of(context).size.width * 0.15,
                                      height: MediaQuery.of(context).size.height*0.15*ratio,
                                    ),
                                  ),Text("Yêu thích",
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.height * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: inloveColor
                                      ))
                                  ]),),
                            ])),
                      ]))),
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
                            style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.05,
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
                            style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.05,
                            fontWeight: FontWeight.bold),
                          ),
                        )),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.13,
                        width: MediaQuery.of(context).size.width*0.15625,
                          child: FlatButton(
                            child: Text(
                              "Kế tiếp",
                              style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.05,
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

  void navigateToAnotherQuestion() async {
    if (choice != "0") {
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
    MyImage image=question.image;
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
                builder: (context) =>
                    EmotionAnswer(widget.myFeedback, sequence, widget.listResponse)));
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
                builder: (context) =>
                    MultiAnswer(widget.myFeedback, sequence, widget.listResponse)));
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
                builder: (context) =>
                    OneAnswer(widget.myFeedback, sequence, widget.listResponse)));
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
