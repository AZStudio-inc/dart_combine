import 'package:dart_combine/dart_combine.dart';

extension PublisherDropFirstExtension<Output, Failure extends Error, Upstream extends Publisher<Output, Failure>> on Publisher<Output, Failure> {
  Publisher<Output, Failure> dropFirst(int count) {
    return DropFirst(
      upstream: this,
      count: count,
    );
  }
}

final class DropFirst<Output, Failure extends Error> implements Publisher<Output, Failure> {
  final Publisher<Output, Failure> _upstream;
  final int _count;
  
  DropFirst({
    required Publisher<Output, Failure> upstream,
    required int count,
  }) : _upstream = upstream,
        _count = count;

  @override
  void receive(Subscriber<Output, Failure> subscriber) {
    final inner = _DropFirstInner<Output, Failure>(
      downstream: subscriber,
      count: _count,
    );
    _upstream.receive(inner);  
  }
}


final class _DropFirstInner<Output, Failure extends Error> implements Subscriber<Output, Failure> {
  final Subscriber<Output, Failure> _downstream;
  final int _count;

  int _dropCount = 0;

  _DropFirstInner({
    required Subscriber<Output, Failure> downstream,
    required int count,
  }) : _downstream = downstream, 
        _count = count;

  @override
  void receive(Output output) {
    if (_dropCount >= _count) {
      _downstream.receive(output);
    }

    _dropCount += 1;
  }

  @override
  void receiveSubscription(Subscription subscription) {
    _downstream.receiveSubscription(subscription);
  }

  @override
  void receiveError(Failure failure) {
    _downstream.receiveError(failure);
  }

  @override
  void receiveCompletion() {
    _downstream.receiveCompletion();
  }
}
