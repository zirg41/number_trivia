import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
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
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });
  // test('initialState should be Empty', () {
  //   expect(bloc., matcher)
  // });
  group('GetTriviaForConcreteNumber event', () {
    const tNumberStringFromUI = '1';
    const tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'text', number: 1);

    test(
        'should call the InputConvertor to validate and convert the string to an insigned integer',
        () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumberStringFromUI));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberStringFromUI));
    });
  });
}
