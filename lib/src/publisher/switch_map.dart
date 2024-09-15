import 'package:dart_combine/dart_combine.dart';

extension SwitchToLatestExtension<Input, Failure extends Error> on Publisher<Input, Failure> {
  Publisher<Output, Failure> switchMap<Output>(Publisher<Output, Failure> Function(Input) mapper) {
    return SwitchMap(mapper: mapper, upstream: this);
  }
}

class SwitchMap<
  Output,
  Input,
  Failure extends Error, 
  Upstream extends Publisher<Input, Failure>
> implements Publisher<Output, Failure> {

  final Upstream _upstream;
  final Publisher<Output, Failure> Function(Input) _mapper;

  const SwitchMap({
    required Upstream upstream,
    required Publisher<Output, Failure> Function(Input) mapper
  }) : _upstream = upstream,
        _mapper = mapper;
  
  @override
  void receive(Subscriber<Output, Failure> subscriber) {
    final inner = _SwitchMapInner<Output, Input, Failure, Upstream>(subscriber, _mapper);
    this._upstream.receive(inner);
  }
}

class _SwitchMapInner<
  Output,
  Input,
  Failure extends Error, 
  Upstream extends Publisher<Input, Failure>
> implements Subscriber<Input, Failure> {
  
  final Subscriber<Output, Failure> _downstream;

  final Publisher<Output, Failure> Function(Input) _mapper;

  Subscription? _currentSubscription;

  _SwitchMapInner(
    Subscriber<Output, Failure> downstream,
    Publisher<Output, Failure> Function(Input) mapper
  ) : _downstream = downstream,
      _mapper = mapper;

  @override
  void receive(Input input) { 
    this._currentSubscription?.cancel();
    
    final publisher = _mapper(input);

    this._currentSubscription = publisher.catchSink(
      _downstream.receive,
      onReceiveError: _downstream.receiveError,
      onReceiveCompletion: _downstream.receiveCompletion
    );
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