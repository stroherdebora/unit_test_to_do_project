import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unit_test_to_do_project/src/cubits/board_cubit.dart';
import 'package:unit_test_to_do_project/src/models/task.dart';
import 'package:unit_test_to_do_project/src/states/board_state.dart';

class BoardPages extends StatefulWidget {
  const BoardPages({super.key});

  @override
  State<BoardPages> createState() => _BoardPagesState();
}

class _BoardPagesState extends State<BoardPages> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => context.read<BoardCubit>().fetchTasks());
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<BoardCubit>();
    final state = cubit.state;

    Widget body = Container();

    if (state is EmptyBoardState) {
      body = Center(
        key: const Key('EmptyState'),
        child: Text('Adicione uma nova Task'),
      );
    } else if (state is LoadedBoardState) {
      final tasks = state.tasks;

      body = ListView.builder(
        key: const Key('LoadedState'),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return GestureDetector(
            onLongPress: () {
              cubit.removeTask(task);
            },
            child: CheckboxListTile(
              value: task.check,
              title: Text(task.description),
              onChanged: (value) {
                cubit.checkTask(task);
              },
            ),
          );
        },
      );
    } else if (state is FailureBoardState) {
      body = Center(
        key: Key('FailureState'),
        child: Text('Falha aos buscar as tasks'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTaskDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void addTaskDialog() {
    var description = '';
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Replace with AlertDialog
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Sair'),
              ),
              TextButton(
                onPressed: () {
                  final task = Task(id: -1, description: description);
                  context.read<BoardCubit>().addTask(task);
                  Navigator.pop(context);
                },
                child: const Text('Criar'),
              )
            ],
            title: const Text('Adicionar uma task'),
            content: TextField(
              onChanged: (value) {
                description = value;
              },
            ),
          );
        });
  }
}
