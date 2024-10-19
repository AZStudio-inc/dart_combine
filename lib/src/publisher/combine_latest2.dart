import 'package:dart_combine/dart_combine.dart';

extension PubilsherCombineLatest2Extension<Input1, Failure extends Error> on Publisher<Input1, Failure> {
  Publisher<Output, Failure> combineLatest2<Input2, Output>(
    Publisher<Input2, Failure> publisher,
    Output Function(Input1, Input2) transform,
  ) {
    return CombineLatest2(
      publisher1: this,
      publisher2: publisher,
      transform: transform,
    );
  }
}

final class CombineLatest2<
  Output,
  Input1,
  Input2,
  Failure extends Error
> implements Publisher<Output, Failure> {
  
  final Publisher<Input1, Failure> _publisher1;
  final Publisher<Input2, Failure> _publisher2;

  final Output Function(Input1, Input2) _transform;

  CombineLatest2({
    required Publisher<Input1, Failure> publisher1,
    required Publisher<Input2, Failure> publisher2,
    required Output Function(Input1, Input2) transform,
  })   : _publisher1 = publisher1,
        _publisher2 = publisher2,
        _transform = transform;

  @override
  void receive(Subscriber<Output, Failure> subscriber) {
    final inner = _CombineLatest2Inner(downstream: subscriber, transform: _transform);

    (int, dynamic) map1(Input1 e) { return (0, e); }
    (int, dynamic) map2(Input2 e) { return (1, e); }

    _publisher1.map(map1).receive(inner);
    _publisher2.map(map2).receive(inner);
  }
}

final class _CombineLatest2Inner<
  Output,
  Input1,
  Input2,
  Failure extends Error
> implements Subscriber<(int, dynamic), Failure> {

  dynamic _latestValue1;
  dynamic _latestValue2;
  
  bool _hasReceived1 = false;
  bool _hasReceived2 = false;

  int _completedCount = 0;

  final Subscriber<Output, Failure> _downstream;

  final Output Function(Input1, Input2) _transform;

  _CombineLatest2Inner({
    required Subscriber<Output, Failure> downstream,
    required Output Function(Input1, Input2) transform,
  }) : _downstream = downstream,
       _transform = transform;
  
  @override
  void receive((int, dynamic) input) {
    if (input.$1 == 0) {
      _latestValue1 = input.$2;
      _hasReceived1 = true;
    } else {
      _latestValue2 = input.$2;
      _hasReceived2 = true;
    }

    if (_hasReceived1 && _hasReceived2) {
      final output = _transform(_latestValue1 as Input1, _latestValue2 as Input2);
      _downstream.receive(output);
    }
  }

  @override
  void receiveError(Failure failure) {
    _downstream.receiveError(failure);
  }

  @override
  void receiveCompletion() {
    _completedCount += 1;
    if (_completedCount == 2) {
      _downstream.receiveCompletion();
    }
  }
  
  @override
  void receiveSubscription(Subscription subscription) {
    _downstream.receiveSubscription(subscription);
  }
}