import 'package:dart_combine/dart_combine.dart';

extension PubilsherCombineLatest2Extension<Input1, Failure extends Error> on Publisher<Input1, Failure> {
  Publisher<(Input1, Input2), Failure> combineLatest2<Input2>(
    Publisher<Input2, Failure> publisher,
  ) {
    return CombineLatest2(
      publisher1: this,
      publisher2: publisher,
    );
  }
}

class CombineLatest2<
  Input1,
  Input2,
  Failure extends Error
> extends Publisher<(Input1, Input2), Failure> {
  final Publisher<Input1, Failure> _publisher1;
  final Publisher<Input2, Failure> _publisher2;

  CombineLatest2({
    required Publisher<Input1, Failure> publisher1,
    required Publisher<Input2, Failure> publisher2,
  })   : _publisher1 = publisher1,
        _publisher2 = publisher2;

  @override
  void receive(Subscriber<(Input1, Input2), Failure> subscriber) {
    final inner = _CombineLatest2Inner(downstream: subscriber);

    (int, dynamic) map1(Input1 e) { return (0, e); }
    (int, dynamic) map2(Input2 e) { return (1, e); }

    _publisher1.map(map1).receive(inner);
    _publisher2.map(map2).receive(inner);
  }
}

class _CombineLatest2Inner<
  Input1,
  Input2,
  Failure extends Error
> implements Subscriber<(int, dynamic), Failure> {

  dynamic _latestValue1;
  dynamic _latestValue2;
  
  bool _hasReceived1 = false;
  bool _hasReceived2 = false;

  int _completedCount = 0;

  final Subscriber<(Input1, Input2), Failure> _downstream;

  _CombineLatest2Inner({
    required Subscriber<(Input1, Input2), Failure> downstream,
  }) : _downstream = downstream;
  
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
      _downstream.receive((_latestValue1, _latestValue2));
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