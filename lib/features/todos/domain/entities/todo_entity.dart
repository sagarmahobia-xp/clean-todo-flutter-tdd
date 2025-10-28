import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final int id;
  final String title;
  final String? content;
  final bool completed;

  const TodoEntity({this.id=0, required this.title, required this.content, this.completed = false});

  TodoEntity copyWith({
    int? id,
    String? title,
    String? content,
    bool? completed,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      completed: completed ?? this.completed,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, content, completed];
}
