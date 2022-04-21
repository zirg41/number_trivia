// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  List properties = const <dynamic>[];

  @override
  List<Object> get props => [properties];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
