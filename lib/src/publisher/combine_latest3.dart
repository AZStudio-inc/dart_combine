import 'package:dart_combine/dart_combine.dart';

extension PubilsherCombineLatest3Extension<Input1, Failure extends Error> on Publisher<Input1, Failure> {
  Publisher<(Input1, Input2, Input3), Failure> combineLatest3<Input2, Input3>(
    Publisher<Input2, Failure> publisher,
    Publisher<Input3, Failure> publisher2,
  ) {
    return CombineLatest3(
      publisher1: this,
      publisher2: publisher,
      publisher3: publisher2,
    );
  }
}

final class CombineLatest3<
  Input1,
  Input2,
  Input3,
  Failure extends Error
> extends Publisher<(Input1, Input2, Input3), Failure> {
  final Publisher<Input1, Failure> _publisher1;
  final Publisher<Input2, Failure> _publisher2;
  final Publisher<Input3, Failure> _publisher3;

  CombineLatest3({
    required Publisher<Input1, Failure> publisher1,
    required Publisher<Input2, Failure> publisher2,
    required Publisher<Input3, Failure> publisher3,
  })   : _publisher1 = publisher1,
        _publisher2 = publisher2,
        _publisher3 = publisher3;

  @override
  void receive(Subscriber<(Input1, Input2, Input3), Failure> subscriber) {
    final inner = _CombineLatest3Inner(downstream: subscriber);

    (int, dynamic) map1(Input1 e) { return (0, e); }
    (int, dynamic) map2(Input2 e) { return (1, e); }
    (int, dynamic) map3(Input3 e) { return (2, e); }

    _publisher1.map(map1).receive(inner);
    _publisher2.map(map2).receive(inner);
    _publisher3.map(map3).receive(inner);
  }
}

final class _CombineLatest3Inner<
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

  final Subscriber<(Input1, Input2, Input3), Failure> _downstream;

  _CombineLatest3Inner({
    required Subscriber<(Input1, Input2, Input3), Failure> downstream,
  }) : _downstream = downstream;
  
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
      _downstream.receive((_latestValue1, _latestValue2, _latestValue3));
    }
  }

  @override
  void receiveError(Failure failure) {
    _downstream.receiveError(failure);
  }

  @override
  void receiveCompletion() {
    _downstream.receiveCompletion();
  }
  
  @override
  void receiveSubscription(Subscription subscription) {
    _downstream.receiveSubscription(subscription);
  }
}