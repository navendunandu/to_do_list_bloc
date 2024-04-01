import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_do_list_bloc/models/task.dart';
import 'package:to_do_list_bloc/services/hive_service.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final HiveService _hiveService = HiveService();

  TaskBloc() : super(TaskLoadingState()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    final tasks = _hiveService.tasksBox.values.toList();
    emit(TaskLoadedState(tasks: tasks));
  }

  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final state = this.state;
    if (state is TaskLoadedState) {
      final task = Task(
        title: event.title,
        description: event.description,
      );
      await _hiveService.tasksBox.add(task);
      final tasks = [...state.tasks, task];
      emit(TaskLoadedState(tasks: tasks));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final state = this.state;
    if (state is TaskLoadedState) {
      final tasks = [...state.tasks];
      final task = tasks[event.index];
      task.isCompleted = !task.isCompleted;
      await task.save();
      emit(TaskLoadedState(tasks: tasks));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final state = this.state;
    if (state is TaskLoadedState) {
      final tasks = [...state.tasks];
      final task = tasks.removeAt(event.index);
      await task.delete();
      emit(TaskLoadedState(tasks: tasks));
    }
  }
}