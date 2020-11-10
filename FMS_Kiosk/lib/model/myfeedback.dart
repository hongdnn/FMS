
import 'package:my_demo/model/question.dart';

class MyFeedback{
  String title;
  String image;
  String description;
  List<Question> questions;
  String token;
  String contentThanks;

  MyFeedback({
    this.title,
    this.image,
    this.description,
    this.questions,
    this.token,
    this.contentThanks,
  });

  MyFeedback.withParams(String title,String image,String description,List<Question> questions,String token,String contentThanks){
    this.title=title;
    this.image=image;
    this.description=description;
    this.questions=questions;
    this.token=token;
    this.contentThanks=contentThanks;
  }

  factory MyFeedback.fromJson(Map<String, dynamic> json) {
    List<Question> questionsJson=[];
    for(var value in json['ListQuestion']){
      questionsJson.add(Question.fromJson(value));
    }

    return MyFeedback(
      title: json['Title'],
      image: json['LinkImageBrand'],
      description: json['DescriptionGift'],
      questions: questionsJson,
      token: json['Token'],
      contentThanks: json['ContentThanks'],
    );
  }
}