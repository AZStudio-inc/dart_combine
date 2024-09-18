import 'package:dart_combine/dart_combine.dart';

extension PublisherTakeExtension<Output, Failure extends Error> on Publisher<Output, Failure> {
  Output? takeValue() {
    Output? output = null;
    this.catchSink((value) { output = value; }, onReceiveError: (_) {});
    return output;
  }

  Failure? takeError() {
    Failure? error = null;
    this.catchSink((_) {}, onReceiveError: (e) { error = e; });
    return error;
  }
}