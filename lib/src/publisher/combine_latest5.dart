import 'package:dart_combine/dart_combine.dart';

extension PubilsherCombineLatest5Extension<Input1, Failure extends Error> on Publisher<Input1, Failure> {
  Publisher<Output, Failure> combineLatest5<Input2, Input3, Input4, Input5, Output>(
    Publisher<Input2, Failure> publisher2,
    Publisher<Input3, Failure> publisher3,
    Publisher<Input4, Failure> publisher4,
    Publisher<Input5, Failure> publisher5,
    Output Function(Input1, Input2, Input3, Input4, Input5) transform,
  ) {
    return CombineLatest5(
      publisher1: this,
      publisher2: publisher2,
      publisher3: publisher3,
      publisher4: publisher4,
      publisher5: publisher5,
      transform: transform,
    );
  }

  Publisher<(Input1, Input2, Input3, Input4, Input5), Failure> combineLatestToRecord5<Input2, Input3, Input4, Input5>(
    Publisher<Input2, Failure> publisher2,
    Publisher<Input3, Failure> publisher3,
    Publisher<Input4, Failure> publisher4,
    Publisher<Input5, Failure> publisher5,
  ) {
    return CombineLatest5(
      publisher1: this,
      publisher2: publisher2,
      publisher3: publisher3,
      publisher4: publisher4,
      publisher5: publisher5,
      transform: (Input1 a, Input2 b, Input3 c, Input4 d, Input5 e) => (a, b, c, d, e),
    );
  }
}

final class CombineLatest5<
  Output,
  Input1,
  Input2,
  Input3,
  Input4,
  Input5,
  Failure extends Error
> implements Publisher<Output, Failure> {
  
  final Publisher<Input1, Failure> _publisher1;
  final Publisher<Input2, Failure> _publisher2;
  final Publisher<Input3, Failure> _publisher3;
  final Publisher<Input4, Failure> _publisher4;
  final Publisher<Input5, Failure> _publisher5;

  final Output Function(Input1, Input2, Input3, Input4, Input5) _transform;

  CombineLatest5({
    required Publisher<Input1, Failure> publisher1,
    required Publisher<Input2, Failure> publisher2,
    required Publisher<Input3, Failure> publisher3,
    required Publisher<Input4, Failure> publisher4,
    required Publisher<Input5, Failure> publisher5,
    required Output Function(Input1, Input2, Input3, Input4, Input5) transform,
  })   : _publisher1 = publisher1,
        _publisher2 = publisher2,
        _publisher3 = publisher3,
        _publisher4 = publisher4,
        _publisher5 = publisher5,
        _transform = transform;

  @override
  void receive(Subscriber<Output, Failure> subscriber) {
    final inner = _CombineLatest5Inner(downstream: subscriber, transform: _transform);

    (int, dynamic) map1(Input1 e) { return (0, e); }
    (int, dynamic) map2(Input2 e) { return (1, e); }
    (int, dynamic) map3(Input3 e) { return (2, e); }
    (int, dynamic) map4(Input4 e) { return (3, e); }
    (int, dynamic) map5(Input5 e) { return (4, e); }

    _publisher1.map(map1).receive(inner);
    _publisher2.map(map2).receive(inner);
    _publisher3.map(map3).receive(inner);
    _publisher4.map(map4).receive(inner);
    _publisher5.map(map5).receive(inner);
  }
}

final class _CombineLatest5Inner<
  Output,
  Input1,
  Input2,
  Input3,
  Input4,
  Input5,
  Failure extends Error
> implements Subscriber<(int, dynamic), Failure> {
  dynamic _latestValue1;
  dynamic _latestValue2;
  dynamic _latestValue3;
  dynamic _latestValue4;
  dynamic _latestValue5;
  
  bool _hasReceived1 = false;
  bool _hasReceived2 = false;
  bool _hasReceived3 = false;
  bool _hasReceived4 = false;
  bool _hasReceived5 = false;

  int _completedCount = 0;

  final Subscriber<Output, Failure> _downstream;

  final Output Function(Input1, Input2, Input3, Input4, Input5) _transform;

  _CombineLatest5Inner({
    required Subscriber<Output, Failure> downstream,
    required Output Function(Input1, Input2, Input3, Input4, Input5) transform,
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
    } else if (input.$1 == 2) {
      _latestValue3 = input.$2;
      _hasReceived3 = true;
    } else if (input.$1 == 3) {
      _latestValue4 = input.$2;
      _hasReceived4 = true;
    } else {
      _latestValue5 = input.$2;
      _hasReceived5 = true;
    }

    if (_hasReceived1 && _hasReceived2 && _hasReceived3 && _hasReceived4 && _hasReceived5) {
      final output = _transform(
        _latestValue1 as Input1, 
        _latestValue2 as Input2, 
        _latestValue3 as Input3, 
        _latestValue4 as Input4,
        _latestValue5 as Input5
      );
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
    if (_completedCount == 5) {
      _downstream.receiveCompletion();
    }
  }
  
  @override
  void receiveSubscription(Subscription subscription) {
    _downstream.receiveSubscription(subscription);
  }
}
