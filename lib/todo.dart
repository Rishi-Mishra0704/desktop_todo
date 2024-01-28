class Todo {
  String title;
  bool isDone;

  Todo({
    required this.title,
    this.isDone = false,
  });

  // Factory method to create a Todo object from a JSON map
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      isDone: json['isDone'] ?? false,
    );
  }

  // Convert the Todo object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }
}
