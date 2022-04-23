import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:number_trivia/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImplOld networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(
    () {
      mockDataConnectionChecker = MockDataConnectionChecker();
      networkInfoImpl = NetworkInfoImplOld(mockDataConnectionChecker);
    },
  );

  group(
    'isConnected',
    () {
      test(
        'should forward the call to DataConnectionChecker.hasConnection',
        () async {
          final tHasConnectionFuture = Future.value(true);
          // arrange
          when(mockDataConnectionChecker.hasConnection)
              .thenAnswer((_) => tHasConnectionFuture);
          // act
          final result = networkInfoImpl.isConnected;
          // assert
          verify(mockDataConnectionChecker.hasConnection);
          expect(result, tHasConnectionFuture);
          ;
        },
      );
    },
  );
}
