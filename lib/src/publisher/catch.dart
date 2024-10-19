import 'package:dart_combine/dart_combine.dart';

extension PublisherCatchExtension<Output, Failure extends Error, Upstream extends Publisher<Output, Failure>> on Publisher<Output, Failure> {
  Publisher<Output, Failure> catchPublisher(void Function(Failure) onReceiveError) {
    return Catch(
      upstream: this,
      onReceiveError: onReceiveError,
    );
  }
}

final class Catch<Output, Failure extends Error, Upstream extends Publisher<Output, Failure>> implements Publisher<Output, Failure> {
  final Upstream _upstream;
  final void Function(Failure) _onReceiveError;

  Catch({
    required Upstream upstream,
    required void Function(Failure) onReceiveError,
  }) : _upstream = upstream,
       _onReceiveError = onReceiveError;

  @override
  void receive(Subscriber<Output, Failure> subscriber) {
    final inner = _CatchInner<Output, Failure>(
      downstream: subscriber,
      onReceiveError: _onReceiveError,
    );
    _upstream.receive(inner);  
  }
}

final class _CatchInner<Output, Failure extends Error> implements Subscriber<Output, Failure> {
  final Subscriber<Output, Failure> _downstream;
  final void Function(Failure) _onReceiveError;

  _CatchInner({
    required Subscriber<Output, Failure> downstream,
    required void Function(Failure) onReceiveError,
  }) : _downstream = downstream, 
        _onReceiveError = onReceiveError;

  @override
  void receive(Output output) {
    _downstream.receive(output);
  }

  @override
  void receiveSubscription(Subscription subscription) {
    _downstream.receiveSubscription(subscription);
  }

  @override
  void receiveError(Failure failure) {
    _onReceiveError(failure);
    _downstream.receiveCompletion();
  }

  @override
  void receiveCompletion() {
    _downstream.receiveCompletion();
  }
}