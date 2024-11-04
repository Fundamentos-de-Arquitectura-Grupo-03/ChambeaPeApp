import 'dart:convert';
import 'package:chambeape/config/constats/environmet.dart';
import 'package:http/http.dart' as http;

class PostulationService {
  final http.Client? client;

  PostulationService({this.client});

  Future<void> createPostulation(int postId, int workerId) async {
    final uri = Uri.parse(
        '${UriEnvironment.baseUrl}/posts/$postId/postulations/$workerId');

    final response = await (client ?? http.Client()).post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: '{}',
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      throw Exception(
          'Failed to create postulation: Status Code ${response.statusCode}, Response Body: ${response.body}');
    }
  }

  Future<void> deletePostulation(int postId, int workerId) async {
    final uri = Uri.parse(
        '${UriEnvironment.baseUrl}/posts/$postId/postulations/$workerId');

    final response = await (client ?? http.Client()).delete(uri);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      throw Exception(
          'Failed to delete postulation: Status Code ${response.statusCode}, Response Body: ${response.body}');
    }
  }

  Future getPostulationByPostIdAndWorkerId(int postId, int workerId) async {
    List<dynamic> postulations = await getPostulationsByPostId(postId);

    for (var postulation in postulations) {
      if (postulation['worker']['id'] == workerId &&
          postulation['postId'] == postId) {
        return postulation;
      }
    }
    return null;
  }

  Future<List<dynamic>> getPostulationsByPostId(int postId) async {
    final uri =
        Uri.parse('${UriEnvironment.baseUrl}/posts/$postId/postulations');

    final response = await (client ?? http.Client()).get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> postulations = json.decode(utf8.decode(response.bodyBytes));
      return postulations;
    } else {
      throw Exception(
          'Failed to fetch postulations: Status Code ${response.statusCode}, Response Body: ${response.body}');
    }
  }

  Future<List<dynamic>> getPostulationsByWorkerId(int workerId) async {
    final uri = Uri.parse('${UriEnvironment.baseUrl}/postulations')
        .replace(queryParameters: {'userId': workerId.toString()});

    final response = await (client ?? http.Client()).get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> postulations = json.decode(utf8.decode(response.bodyBytes));
      return postulations;
    } else {
      throw Exception(
          'Failed to fetch postulations: Status Code ${response.statusCode}, Response Body: ${response.body}');
    }
  }
}
