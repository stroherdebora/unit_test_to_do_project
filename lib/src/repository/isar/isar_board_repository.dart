import 'package:unit_test_to_do_project/src/models/task.dart';
import 'package:unit_test_to_do_project/src/repository/board_repository.dart';
import 'package:unit_test_to_do_project/src/repository/isar/task_model.dart';

import 'isar_datasource.dart';

class IsarBoardRepository implements BoardRepository {
  final IsarDatasource datasource;

  IsarBoardRepository(this.datasource);

  @override
  Future<List<Task>> fetch() async {
    final models = await datasource.getTasks();
    return models
        .map((e) => Task(id: e.id, description: e.description, check: e.check))
        .toList();
  }

  @override
  Future<List<Task>> update(List<Task> tasks) async {
    final models = tasks.map((e) {
      final model = TaskModel()
        ..check = e.check
        ..description = e.description;

      if (e.id != -1) {
        model.id = e.id;
      }
      return model;
    }).toList();

    await datasource.deleteAllTasks();
    await datasource.putAllTasks(models);
    return tasks;
  }
}
