import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockConnectivity mockConnectivity;

  setUp(
    () {
      mockConnectivity = MockConnectivity();
      networkInfoImpl = NetworkInfoImpl(mockConnectivity);
    },
  );

  group(
    'NetworkInfoImpl',
    () {
      test(
        "should return true if device is connected to wifi",
        () async {
          // arrange
          when(mockConnectivity.checkConnectivity())
              .thenAnswer((_) => Future.value(ConnectivityResult.wifi));
          // act
          final result = await networkInfoImpl.isConnected;
          // assert
          expect(result, true);
        },
      );
    },
  );
}
