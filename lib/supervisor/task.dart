class Task {
  final int id;
  final String description;
  final DateTime deadline;
  final bool isHighPriority;
  final bool isMediumPriority;
  final bool isLowPriority;
  final String status;

  Task({
    required this.id,
    required this.description,
    required this.deadline,
    required this.isHighPriority,
    required this.isMediumPriority,
    required this.isLowPriority,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      isHighPriority: json['isHighPriority'],
      isMediumPriority: json['isMediumPriority'],
      isLowPriority: json['isLowPriority'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'isHighPriority': isHighPriority,
      'isMediumPriority': isMediumPriority,
      'isLowPriority': isLowPriority,
      'status': status,
    };
  }
}
