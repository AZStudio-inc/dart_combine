import 'package:dart_combine/dart_combine.dart';

extension PubilsherCombineLatest3Extension<Input1, Failure extends Error> on Publisher<Input1, Failure> {
  Publisher<Output, Failure> combineLatest3<Input2, Input3, Output>(
    Publisher<Input2, Failure> publisher2,
    Publisher<Input3, Failure> publisher3,
    Output Function(Input1, Input2, Input3) transform,
  ) {
    return CombineLatest3(
      publisher1: this,
      publisher2: publisher2,
      publisher3: publisher3,
      transform: transform,
    );
  }
}

final class CombineLatest3<
  Output,
  Input1,
  Input2,
  Input3,
  Failure extends Error
> implements Publisher<Output, Failure> {
  
  final Publisher<Input1, Failure> _publisher1;
  final Publisher<Input2, Failure> _publisher2;
  final Publisher<Input3, Failure> _publisher3;

  final Output Function(Input1, Input2, Input3) _transform;

  CombineLatest3({
    required Publisher<Input1, Failure> publisher1,
    required Publisher<Input2, Failure> publisher2,
    required Publisher<Input3, Failure> publisher3,
    required Output Function(Input1, Input2, Input3) transform,
  })   : _publisher1 = publisher1,
        _publisher2 = publisher2,
        _publisher3 = publisher3,
        _transform = transform;

  @override
  void receive(Subscriber<Output, Failure> subscriber) {
    final inner = _CombineLatest3Inner(downstream: subscriber, transform: _transform);

    (int, dynamic) map1(Input1 e) { return (0, e); }
    (int, dynamic) map2(Input2 e) { return (1, e); }
    (int, dynamic) map3(Input3 e) { return (2, e); }

    _publisher1.map(map1).receive(inner);
    _publisher2.map(map2).receive(inner);
    _publisher3.map(map3).receive(inner);
  }
}

final class _CombineLatest3Inner<
  Output,
  Input1,
  Input2,
  Input3,
  Failure extends Error
> implements Subscriber<(int, dynamic), Failure> {

  dynamic _latestValue1;
  dynamic _latestValue2;
  dynamic _latestValue3;
  
  bool _hasReceived1 = false;
  bool _hasReceived2 = false;
  bool _hasReceived3 = false;

  int _completedCount = 0;

  final Subscriber<Output, Failure> _downstream;

  final Output Function(Input1, Input2, Input3) _transform;

  _CombineLatest3Inner({
    required Subscriber<Output, Failure> downstream,
    required Output Function(Input1, Input2, Input3) transform,
  }) : _downstream = downstream,
      _transform = transform;
  
  @override
  void receive((int, dynamic) input) {
    if (input.$1 == 0) {
      _latestValue1 = input.$2;
      _hasReceived1 = true;
    } else if (input.$1 == 1) {
      _latestValue2 = input.$2;
      _hasReceived2 = true;
    } else {
      _latestValue3 = input.$2;
      _hasReceived3 = true;
    }

    if (_hasReceived1 && _hasReceived2 && _hasReceived3) {
      final output = _transform(_latestValue1 as Input1, _latestValue2 as Input2, _latestValue3 as Input3);
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
    if (_completedCount == 3) {
      _downstream.receiveCompletion();
    }
  }
  
  @override
  void receiveSubscription(Subscription subscription) {
    _downstream.receiveSubscription(subscription);
  }
}
