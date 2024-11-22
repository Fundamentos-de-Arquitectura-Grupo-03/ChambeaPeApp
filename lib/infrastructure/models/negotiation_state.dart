import 'package:chambeape/infrastructure/models/post_state.dart';

class NegotiationState {
  final int id;
  final int workerId;
  final int employerId;
  final DateTime startDay;
  final DateTime endDay;
  final double salary;
  final String state;
  final PostState post;

  NegotiationState({
    required this.id,
    required this.workerId,
    required this.employerId,
    required this.startDay,
    required this.endDay,
    required this.salary,
    required this.state,
    required this.post,
  });

  factory NegotiationState.fromJson(Map<String, dynamic> json) =>
      NegotiationState(
        id: json["id"],
        workerId: json["workerId"],
        employerId: json["employerId"],
        startDay: DateTime.parse(json["startDay"]),
        endDay: DateTime.parse(json["endDay"]),
        salary: json["salary"]?.toDouble(),
        state: json["state"],
        post: PostState.fromJson(json["post"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "workerId": workerId,
        "employerId": employerId,
        "startDay": startDay.toIso8601String(),
        "endDay": endDay.toIso8601String(),
        "salary": salary,
        "state": state,
        "post": post.toJson(),
      };
}
