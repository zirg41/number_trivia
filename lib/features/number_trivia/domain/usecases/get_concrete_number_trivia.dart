import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:number_trivia/core/usecases/usecase.dart';

import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';
import '../../../../core/errors/failures.dart';

import 'package:dartz/dartz.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({@required this.number});

  @override
  List<Object> get props => [number];
}
