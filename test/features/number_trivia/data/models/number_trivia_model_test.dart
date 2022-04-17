import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test text");

  test('should be a subclass of NumberTrivia entity', () async {
    expect(testNumberTriviaModel, isA<NumberTrivia>());
  });
}
