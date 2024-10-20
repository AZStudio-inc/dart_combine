import 'package:dart_combine/dart_combine.dart';

abstract interface class Subject<Output, Failure extends Error> implements Publisher<Output, Failure> {
  void send(Output value);

  void sendError(Failure failure);

  void sendCompletion();
}