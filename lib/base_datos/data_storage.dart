import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:fisma_inso2/models/agent_model.dart';

class DataStorage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/agents.json');
  }

  static Future<List<Agent>> loadAgents() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) return [];
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => Agent.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<File> saveAgents(List<Agent> agents) async {
    final file = await _localFile;
    final List<Map<String, dynamic>> jsonList =
        agents.map((agent) => agent.toJson()).toList();
    return file.writeAsString(json.encode(jsonList));
  }
}
