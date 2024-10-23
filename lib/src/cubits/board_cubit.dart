import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../repository/board_repository.dart';
import '../states/board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository repository;

  BoardCubit(this.repository) : super(EmptyBoardState());

  Future<void> fetchTasks() async {
    emit(LoadingBoardState());
    try {
      final tasks = await repository.fetch();
      emit(LoadedBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState('Error'));
    }
  }

  Future<void> addTask(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    tasks.add(newTask);
    await emitTasks(tasks);
  }

  Future<void> removeTask(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    tasks.remove(newTask);
    await emitTasks(tasks);
  }

  Future<void> checkTask(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    final index = tasks.indexOf(newTask);
    tasks[index] = newTask.copyWith(check: !newTask.check);
    await emitTasks(tasks);
  }

  @visibleForTesting
  void addTasks(List<Task> tasks) {
    emit(LoadedBoardState(tasks: tasks));
  }

  List<Task>? _getTasks() {
    final state = this.state;
    if (state is! LoadedBoardState) {
      return null;
    }

    return state.tasks.toList();
  }

  Future<void> emitTasks(List<Task> tasks) async {
    try {
      await repository.update(tasks);
      emit(LoadedBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState('Error'));
    }
  }
}
