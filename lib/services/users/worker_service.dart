import 'dart:convert';
import 'package:chambeape/infrastructure/models/workers.dart';
import 'package:http/http.dart' as http;

Future<List<Workers>> getWorkers() async {
  final uri = Uri.parse('https://chambeapeapi-a4anbthqamgre7ce.eastus-01.azurewebsites.net/api/v1/workers');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    List<dynamic> json = jsonDecode(body);
    List<Workers> workers =
        json.map((dynamic item) => Workers.fromJson(item)).toList();
    return workers;
  } else {
    throw Exception('Failed to load Workers');
  }
}
