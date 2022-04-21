import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/errors/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTriviaUseCase;
  MockGetRandomNumberTrivia mockGetRandomNumberTriviaUseCase;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTriviaUseCase = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTriviaUseCase = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTriviaUseCase,
        getRandomNumberTrivia: mockGetRandomNumberTriviaUseCase,
        inputConverter: mockInputConverter);
  });
  // test('initialState should be Empty', () {
  //   expect(bloc., matcher)
  // });
  group('GetTriviaForConcreteNumber event', () {
    const String tNumberStringFromUI = '1';
    const tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'text', number: 1);

    void setUpMockInputConvertterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
    }

    test(
      'should call the InputConverter to validate and convert the string to an insigned integer',
      () async {
        // arrange
        setUpMockInputConvertterSuccess();
        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberStringFromUI));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberStringFromUI));
      },
    );
    test(
      'should emit [Error] when the input is invalid',
      () async* {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

        // assert later
        final expected = <NumberTriviaState>[
          Empty(),
          const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];

        expectLater(
            bloc.stream.asBroadcastStream().cast(), emitsInOrder(expected));

        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberStringFromUI));
      },
    );

    test(
      'should get data from concrete usecase',
      () async {
        //arrange
        setUpMockInputConvertterSuccess();
        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        //act
        bloc.add(const GetTriviaForConcreteNumber(tNumberStringFromUI));
        await untilCalled(mockGetConcreteNumberTriviaUseCase(any));
        //assert
        verify(
            mockGetConcreteNumberTriviaUseCase(Params(number: tNumberParsed)));
      },
    );
    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        //arrange
        setUpMockInputConvertterSuccess();
        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        //assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(
            bloc.stream.asBroadcastStream().cast(), emitsInOrder(expected));
        //act
        bloc.add(const GetTriviaForConcreteNumber(tNumberStringFromUI));
      },
    );
    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        //arrange
        setUpMockInputConvertterSuccess();
        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        //assert later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(
            bloc.stream.asBroadcastStream().cast(), emitsInOrder(expected));
        //act
        bloc.add(const GetTriviaForConcreteNumber(tNumberStringFromUI));
      },
    );
    test(
      'should emit [Loading, Error] with proper message for the error when getting data fails',
      () async {
        //arrange
        setUpMockInputConvertterSuccess();
        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        //assert later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(
            bloc.stream.asBroadcastStream().cast(), emitsInOrder(expected));
        //act
        bloc.add(const GetTriviaForConcreteNumber(tNumberStringFromUI));
      },
    );
  });
  group('GetTriviaForRandomNumber event', () {
    final tNumberTrivia = NumberTrivia(text: 'text', number: 1);

    test(
      'should get data from random usecase',
      () async {
        //arrange
        when(mockGetRandomNumberTriviaUseCase(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        //act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTriviaUseCase(any));
        //assert
        verify(mockGetRandomNumberTriviaUseCase(NoParams()));
      },
    );
    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        //arrange
        when(mockGetRandomNumberTriviaUseCase(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        //assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(
            bloc.stream.asBroadcastStream().cast(), emitsInOrder(expected));
        //act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        //arrange
        when(mockGetRandomNumberTriviaUseCase(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        //assert later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(
            bloc.stream.asBroadcastStream().cast(), emitsInOrder(expected));
        //act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
    test(
      'should emit [Loading, Error] with proper messagr for the error when getting data fails',
      () async {
        //arrange
        when(mockGetRandomNumberTriviaUseCase(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        //assert later
        final expected = [
          Empty(),
          Loading(),
          const Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(
            bloc.stream.asBroadcastStream().cast(), emitsInOrder(expected));
        //act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
