class Negotiation {
  int id;
  int workerId;
  int employerId;
  DateTime startDay;
  DateTime endDay;
  double salary;
  String state;
  int postId;

  Negotiation({
    required this.id,
    required this.workerId,
    required this.employerId,
    required this.startDay,
    required this.endDay,
    required this.salary,
    required this.state,
    required this.postId,
  });

  factory Negotiation.fromJson(Map<String, dynamic> json) => Negotiation(
        id: json["id"],
        workerId: json["workerId"],
        employerId: json["employerId"],
        startDay: DateTime.parse(json["startDay"]),
        endDay: DateTime.parse(json["endDay"]),
        salary: json["salary"],
        state: json["state"],
        postId: json["postId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "workerId": workerId,
        "employerId": employerId,
        "startDay": startDay.toIso8601String(),
        "endDay": endDay.toIso8601String(),
        "salary": salary,
        "state": state,
        "postId": postId,
      };
}
