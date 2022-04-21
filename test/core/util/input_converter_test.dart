import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(
    () {
      inputConverter = InputConverter();
    },
  );

  group(
    'stringToUnsignedInt',
    () {
      test(
        'should return an integer when the string represents an unsigned integet',
        () async {
          const str = '123';
          final result = inputConverter.stringToUnsignedInteger(str);
          expect(result, Right(123));
        },
      );
      test(
        'should return a Failure when the string is not an integer',
        () async {
          const str = '1.0';
          final result = inputConverter.stringToUnsignedInteger(str);
          expect(result, Left(InvalidInputFailure()));
        },
      );
    },
  );
}