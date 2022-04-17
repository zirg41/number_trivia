import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class Failure extends Equatable {
  List properties = const <dynamic>[];

  Failure(this.properties);

  @override
  List<Object> get props => [properties];
}
