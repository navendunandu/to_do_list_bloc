part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final String title;
  final String description;

  const AddTaskEvent({
    required this.title,
    required this.description,
  });

  @override
  List<Object> get props => [title, description];
}

class UpdateTaskEvent extends TaskEvent {
  final int index;

  const UpdateTaskEvent({required this.index});

  @override
  List<Object> get props => [index];
}

class DeleteTaskEvent extends TaskEvent {
  final int index;

  const DeleteTaskEvent({required this.index});

  @override
  List<Object> get props => [index];
}