import 'package:dart_combine/dart_combine.dart';

abstract class Subject<Output, Failure extends Error> extends Publisher<Output, Failure> {
  void send(Output value);

  void sendError(Failure failure);

  void sendCompletion();
}