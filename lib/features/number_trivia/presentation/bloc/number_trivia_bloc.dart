// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive inteher or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTriviaUseCase;
  final GetRandomNumberTrivia getRandomNumberTriviaUseCase;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required this.getConcreteNumberTriviaUseCase,
    @required this.getRandomNumberTriviaUseCase,
    @required this.inputConverter,
  }) : super(Empty()) {
    on<NumberTriviaEvent>(
      (event, emit) async {
        emit(Empty());
        if (event is GetTriviaForConcreteNumber) {
          final Either<Failure, int> inputEither =
              inputConverter.stringToUnsignedInteger(event.numberString);

          await inputEither.fold(
            (failure) async {
              emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
            },
            (integer) async {
              emit(Loading());
              final failureOrTrivia =
                  await getConcreteNumberTriviaUseCase(Params(number: integer));
              emit(failureOrTrivia.fold(
                (failure) => Error(message: _mapFailureToMessage(failure)),
                (trivia) => Loaded(trivia: trivia),
              ));
            },
          );
        } else if (event is GetTriviaForRandomNumber) {
          emit(Loading());
          final failureOrTrivia =
              await getRandomNumberTriviaUseCase(NoParams());
          emit(failureOrTrivia.fold(
            (failure) => Error(message: _mapFailureToMessage(failure)),
            (trivia) => Loaded(trivia: trivia),
          ));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected error";
    }
  }
}
