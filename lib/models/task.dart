import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  final String description;
  DateTime deadline;
  final bool isHighPriority;
  final bool isMediumPriority;
  final bool isLowPriority;
  final String status;
  final String assignedUserId;

  Task({
    required this.id,
    required this.description,
    required this.deadline,
    required this.isHighPriority,
    required this.isMediumPriority,
    required this.isLowPriority,
    required this.status,
    required this.assignedUserId,
  });

  // Crear tarea desde un Map
  factory Task.fromMap(Map<String, dynamic> data) {
    String userId = '';
    final assignedUser = data['assignedUser'];
    if (assignedUser is Map) {
      userId = assignedUser['id']?.toString() ?? '';
    } else if (assignedUser is String) {
      userId = assignedUser;
    }

    return Task(
      id: data['id']?.toString() ?? '',
      description: data['description'] ?? '',
      deadline: (data['deadline'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isHighPriority: data['isHighPriority'] ?? false,
      isMediumPriority: data['isMediumPriority'] ?? false,
      isLowPriority: data['isLowPriority'] ?? false,
      status: data['status'] ?? '',
      assignedUserId: userId,
    );
  }

  // Crear tarea desde Firestore
  factory Task.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return Task.fromMap({...data, 'id': doc.id});
}

  // Convertir tarea a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'deadline': Timestamp.fromDate(deadline),
      'isHighPriority': isHighPriority,
      'isMediumPriority': isMediumPriority,
      'isLowPriority': isLowPriority,
      'status': status,
      'assignedUser': assignedUserId,
    };
  }

  // Crear tarea vacía
  factory Task.empty() {
    return Task(
      id: '',
      description: '',
      deadline: DateTime.now(),
      isHighPriority: false,
      isMediumPriority: false,
      isLowPriority: false,
      status: '',
      assignedUserId: '',
    );
  }
}
