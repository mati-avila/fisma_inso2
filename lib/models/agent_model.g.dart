// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Agent _$AgentFromJson(Map<String, dynamic> json) => Agent(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      estadoDeTareas: json['estadoDeTareas'] as String,
      fechaUltimoAcceso: json['fechaUltimoAcceso'] as String,
      informeReciente: json['informeReciente'] as String,
      rol: json['rol'] as String,
    );

Map<String, dynamic> _$AgentToJson(Agent instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'estadoDeTareas': instance.estadoDeTareas,
      'fechaUltimoAcceso': instance.fechaUltimoAcceso,
      'informeReciente': instance.informeReciente,
      'rol': instance.rol,
    };
