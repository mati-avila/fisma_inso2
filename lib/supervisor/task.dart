import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart'; // Este archivo será generado automáticamente

@JsonSerializable()
class Task {
  final String id;
  final String description;
  final DateTime? deadline; // Cambiado a DateTime?
  final bool isHighPriority;
  final bool isMediumPriority;
  final bool isLowPriority;
  final String status;

  Task({
    required this.id,
    required this.description,
    this.deadline, // Cambiado a DateTime?
    required this.isHighPriority,
    required this.isMediumPriority,
    required this.isLowPriority,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
