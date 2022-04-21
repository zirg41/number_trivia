import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(
    () {
      mockHttpClient = MockHttpClient();
      dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
    },
  );

  group(
    'getConcreteNumberTrivia',
    () {
      const tNumber = 1;
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
      test(
        '''should perform a GET request on a URL with number 
        being the endpoint and with application/json header''',
        () async {
          // arrange
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer(
                  (_) async => http.Response(fixture('trivia.json'), 200));
          // act
          dataSource.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockHttpClient.get(Uri(path: 'http://numbersapi.com/$tNumber'),
              headers: {'Content-Type': 'application/json'}));
        },
      );
      test(
        'should return NumberTrivia when the response code is 200(success)',
        () async {
          // arrange
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer(
                  (_) async => http.Response(fixture('trivia.json'), 200));
          // act
          final result = await dataSource.getConcreteNumberTrivia(tNumber);
          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );
    },
  );
}
