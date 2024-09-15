// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String,
      description: json['description'] as String,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      isHighPriority: json['isHighPriority'] as bool,
      isMediumPriority: json['isMediumPriority'] as bool,
      isLowPriority: json['isLowPriority'] as bool,
      status: json['status'] as String,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'deadline': instance.deadline?.toIso8601String(),
      'isHighPriority': instance.isHighPriority,
      'isMediumPriority': instance.isMediumPriority,
      'isLowPriority': instance.isLowPriority,
      'status': instance.status,
    };
