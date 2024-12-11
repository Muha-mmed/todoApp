class Todo {
  String? id;
  final String title;
  String? description;

  Todo({
    this.id,
    required this.title,
    this.description,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] != null ? map['id'] as String : null,
      title: (map['title'] ?? '') as String,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }
}
