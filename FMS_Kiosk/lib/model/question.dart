import 'package:my_demo/model/myimage.dart';

class Question{
  String questionId;
  int typeOfSurvey;
  String contentQuestion;
  String answerOption;
  MyImage image;

  Question({
    this.questionId,
    this.typeOfSurvey,
    this.contentQuestion,
    this.answerOption,
    this.image
  });

  Question.withParams(String questionId, int typeOfSurvey,String contentQuestion,String answerOption,MyImage image){
    this.questionId=questionId;
    this.typeOfSurvey=typeOfSurvey;
    this.contentQuestion=contentQuestion;
    this.answerOption=answerOption;
    this.image=image;
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    if(json['Image']==null){
      return Question(
      questionId: json['QuestionId'],
      typeOfSurvey: json['TypeOfQuestion'],
      contentQuestion: json['ContentQuestion'],
      answerOption: json['AnswerOption'],
      image: null,
    );
    }
    return Question(
      questionId: json['QuestionId'],
      typeOfSurvey: json['TypeOfQuestion'],
      contentQuestion: json['ContentQuestion'],
      answerOption: json['AnswerOption'],
      image: MyImage.fromJson(json['Image']),
    );
  }
}