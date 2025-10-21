import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final int id;
  final String title;
  final String? content;

  const TodoEntity({  this.id=0, required this.title, required this.content});

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, content];
}
