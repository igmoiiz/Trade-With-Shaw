class Signal {
  final String id;
  final String title;
  final String description;
  final String type;
  final String createdBy;
  final DateTime? createdAt;

  Signal({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.createdBy,
    this.createdAt,
  });

  factory Signal.fromJson(Map<String, dynamic> json) {
    return Signal(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      createdBy:
          json['createdBy'] is Map
              ? (json['createdBy']['email'] ?? '')
              : (json['createdBy'] ?? ''),
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type,
    'createdBy': createdBy,
    'createdAt': createdAt?.toIso8601String(),
  };
}
