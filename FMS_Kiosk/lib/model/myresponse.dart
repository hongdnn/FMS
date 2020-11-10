class MyResponse {
  String responseTime;
  String questionId;
  String responseDetail;
  String userAgent;
  String email;
  String equipmentId;

  MyResponse({
    this.responseTime,
    this.questionId,
    this.responseDetail,
    this.userAgent,
    this.email,
    this.equipmentId
  });

  MyResponse.personalIdea({
    this.responseTime,
    this.responseDetail,
    this.userAgent,
    this.email,
    this.equipmentId
  });

  MyResponse.withParams(String responseTime, String questionId,
      String responseDetail, String userAgent, String email, String equipmentId) {
    this.responseTime = responseTime;
    this.questionId = questionId;
    this.responseDetail = responseDetail;
    this.userAgent = userAgent;
    this.email = email;
    this.equipmentId = equipmentId;
  }

  factory MyResponse.fromJson(Map<dynamic, dynamic> json) {
    return MyResponse(
      responseTime: json['ResponseTime'],
      questionId: json['QuestionId'],
      responseDetail: json['ResponseDetail'],
      userAgent: json['UserAgent'],
      email: json['Email'],
    );
  }

  Map toJson() => {
        'ResponseTime': responseTime,
        'QuestionId': questionId,
        'ResponseDetail': responseDetail,
        'UserAgent': userAgent,
        'Email': email,
        'EquipmentId': equipmentId
      };

  Map personalIdeaToJson() => {
        'ResponseTime': responseTime,
        'ResponseDetail': responseDetail,
        'UserAgent': userAgent,
        'Email': email,
        'EquipmentId': equipmentId
      };
}
