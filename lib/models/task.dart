import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore Timestamp
import 'user.dart'; // Importar la clase User

class Task {
  final String id;
  final String description;
  final DateTime deadline;
  final bool isHighPriority;
  final bool isMediumPriority;
  final bool isLowPriority;
  final String status;
  final User assignedUser;

  Task({
    required this.id,
    required this.description,
    required this.deadline,
    required this.isHighPriority,
    required this.isMediumPriority,
    required this.isLowPriority,
    required this.status,
    required this.assignedUser,
  });

  // Factory constructor para crear una Task desde un documento Firestore
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      description: data['description'] ?? '',
      deadline: (data['deadline'] as Timestamp).toDate(), // Convertir Timestamp a DateTime
      isHighPriority: data['isHighPriority'] ?? false,
      isMediumPriority: data['isMediumPriority'] ?? false,
      isLowPriority: data['isLowPriority'] ?? false,
      status: data['status'] ?? '',
      assignedUser: User.fromFirestore(data['assignedUser']), // Asumir que 'assignedUser' es un documento de Firestore
    );
  }

  // Método para convertir una Task a un mapa Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'deadline': Timestamp.fromDate(deadline), // Convertir DateTime a Timestamp
      'isHighPriority': isHighPriority,
      'isMediumPriority': isMediumPriority,
      'isLowPriority': isLowPriority,
      'status': status,
      'assignedUser': assignedUser.toFirestore(), // Convertir assignedUser a un formato compatible con Firestore
    };
  }
}
