import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unit_test_to_do_project/src/cubits/board_cubit.dart';
import 'package:unit_test_to_do_project/src/repository/board_repository.dart';
import 'package:unit_test_to_do_project/src/repository/isar/isar_board_repository.dart';
import 'package:unit_test_to_do_project/src/repository/isar/isar_datasource.dart';

import 'src/pages/board_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// Sistema de injeção de dependências
        RepositoryProvider(create: (ctx) => IsarDatasource()),
        RepositoryProvider<BoardRepository>(create: (ctx) => IsarBoardRepository(ctx.read())),
        BlocProvider(create: (ctx) => BoardCubit(ctx.read())),
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.purple),
        home: BoardPages(),
      ),
    );
  }
}
