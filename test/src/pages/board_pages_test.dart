import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_test_to_do_project/src/cubits/board_cubit.dart';
import 'package:unit_test_to_do_project/src/pages/board_pages.dart';
import 'package:unit_test_to_do_project/src/repository/board_repository.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit;

  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });
  testWidgets('board pages with all tasks', (tester) async {
    when(() => repository.fetch()).thenAnswer((_) async => []);
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(home: BoardPages()),
      ),
    );

    expect(find.byKey(const Key('EmptyState')), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(const Key('LoadedState')), findsOneWidget);
  });

  testWidgets('board pages with failure state', (tester) async {
    when(() => repository.fetch()).thenThrow(Exception('Error'));

    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(home: BoardPages()),
      ),
    );

    expect(find.byKey(const Key('EmptyState')), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(const Key('FailureState')), findsOneWidget);
  });
}
