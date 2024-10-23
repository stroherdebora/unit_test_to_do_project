import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_test_to_do_project/src/cubits/board_cubit.dart';
import 'package:unit_test_to_do_project/src/models/task.dart';
import 'package:unit_test_to_do_project/src/repository/board_repository.dart';
import 'package:unit_test_to_do_project/src/states/board_state.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit;
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });

  group('fetchTasks | ', () {
    test('should fetch all tasks', () async {
      when(() => repository.fetch()).thenAnswer(
        (_) async => [
          const Task(id: 1, description: ""),
        ],
      );

      expect(
          cubit.stream,
          emitsInOrder([
            isA<LoadingBoardState>(),
            isA<LoadedBoardState>(),
          ]));

      await cubit.fetchTasks();
    });

    test('Should return error state when failed', () async {
      when(() => repository.fetch()).thenThrow(Exception('Error'));

      expect(
          cubit.stream,
          emitsInOrder(
            [
              isA<LoadingBoardState>(),
              isA<FailureBoardState>(),
            ],
          ));

      await cubit.fetchTasks();
    });
  });

  group('addTask | ', () {
    test(
      'should add one task',
      () async {
        when(() => repository.update(any())).thenAnswer((_) async => []);

        expect(
            cubit.stream,
            emitsInOrder([
              isA<LoadedBoardState>(),
            ]));

        const task = Task(id: 1, description: "");
        await cubit.addTask(task);
        final state = cubit.state as LoadedBoardState;
        expect(state.tasks.length, 1);
        expect(state.tasks, [task]);
      },
    );

    test('Should return error state when failed', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));

      expect(
          cubit.stream,
          emitsInOrder(
            [
              isA<FailureBoardState>(),
            ],
          ));

      const task = Task(id: 1, description: '');
      await cubit.addTask(task);
    });
  });

  /// To remove a task it must already be in the list for it to work.
  /// Use @visibleForTesting

  group('removeTask | ', () {
    test(
      'should remove one task',
      () async {
        when(() => repository.update(any())).thenAnswer((_) async => []);
        const task = Task(id: 1, description: "");
        cubit.addTasks([task]);
        expect((cubit.state as LoadedBoardState).tasks.length, 1);

        expect(
            cubit.stream,
            emitsInOrder([
              isA<LoadedBoardState>(),
            ]));

        await cubit.removeTask(task);
        final state = cubit.state as LoadedBoardState;
        expect(state.tasks.length, 0);
      },
    );

    test('Should return error state when failed', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));
      const task = Task(id: 1, description: '');
      cubit.addTasks([task]);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );

      await cubit.removeTask(task);
    });
  });

  group('checkTask | ', () {
    test(
      'should check one task',
      () async {
        when(() => repository.update(any())).thenAnswer((_) async => []);
        const task = Task(id: 1, description: "");
        cubit.addTasks([task]);
        expect((cubit.state as LoadedBoardState).tasks.length, 1);
        expect((cubit.state as LoadedBoardState).tasks.first.check, false);

        expect(
          cubit.stream,
          emitsInOrder([
            isA<LoadedBoardState>(),
          ]),
        );

        await cubit.checkTask(task);
        final state = cubit.state as LoadedBoardState;
        expect(state.tasks.length, 1);
        expect(state.tasks.first.check, true);
      },
    );

    test('Should return error state when failed', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));
      const task = Task(id: 1, description: '');
      cubit.addTasks([task]);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );

      await cubit.checkTask(task);
    });
  });
}
