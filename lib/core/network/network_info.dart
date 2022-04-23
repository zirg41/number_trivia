import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImplOld implements NetworkInfo {
  final DataConnectionChecker connectionChecker;

  NetworkInfoImplOld(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return Future.value(true);
    }

    return Future.value(false);
  }
}
