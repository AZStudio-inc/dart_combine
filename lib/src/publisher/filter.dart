import 'package:dart_combine/dart_combine.dart';

extension PublisherFilterExtension<Output, Failure extends Error, Upstream extends Publisher<Output, Failure>> on Publisher<Output, Failure> {
  Publisher<Output, Failure> filter(bool Function(Output) predicate) {
    return Filter(
      upstream: this,
      predicate: predicate,
    );
  }
}

final class Filter<Output, Failure extends Error, Upstream extends Publisher<Output, Failure>> implements Publisher<Output, Failure> {
  final bool Function(Output) _predicate;
  final Upstream _upstream;

  Filter({
    required Upstream upstream,
    required bool Function(Output) predicate,
  }) : _predicate = predicate,
        _upstream = upstream;

  void receive(Subscriber<Output, Failure> subscriber) {
    final inner = _FilterInner<Output, Failure>(
      downstream: subscriber,
      predicate: _predicate,
    );
    _upstream.receive(inner);  
  }
}

final class _FilterInner<Output, Failure extends Error> implements Subscriber<Output, Failure> {
  final Subscriber<Output, Failure> _downstream;
  final bool Function(Output) _predicate;

  _FilterInner({
    required Subscriber<Output, Failure> downstream,
    required bool Function(Output) predicate,
  }) : _downstream = downstream, 
        _predicate = predicate;

  @override
  void receive(Output output) {
    if (_predicate(output)) {
      _downstream.receive(output);
    }
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