import 'package:equatable/equatable.dart';

/// Equatable
/// -----------------------------------------------------------
/// Ele não vai comparar o hash de cada instância de classe.
/// A lista de propriedades vai ser usada para determinar se
/// duas instâncias são iguais.
/// Pode ser utilizado também como Mixin -> with EquatableMixin
/// -----------------------------------------------------------

class Task extends Equatable {
  final int id;
  final String description;
  final bool check;

  const Task({
    required this.id,
    required this.description,
    this.check = false,
  });

  @override
  List<Object?> get props => [id, description, check];

  Task copyWith({
    int? id,
    String? description,
    bool? check,
  }) {
    return Task(
      id: id ?? this.id,
      description: description ?? this.description,
      check: check ?? this.check,
    );
  }
}
