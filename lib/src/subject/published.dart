import 'package:dart_combine/dart_combine.dart';

class Published<Output> extends Subject<Output, Never> {
  final List<_PublishedSubscription<Output>> _subscriptions = [];

  Output _currentValue;

  Output get value => _currentValue;
  
  set value(Output value) => send(value);

  void send(Output value) {
    this._currentValue = value;
    for (final subscription in _subscriptions) {
      subscription.receive(value);
    }
  }

  void sendError(Never failure) {
    throw UnimplementedError();
  }

  void sendCompletion() {
    throw UnimplementedError();
  }

  Published(Output initialValue) : _currentValue = initialValue;

  @override
  void receive(Subscriber<Output, Never> subscriber) {
    final subscription = _PublishedSubscription(this, subscriber);
    subscriber.receiveSubscription(subscription);
    _subscriptions.add(subscription);
    subscriber.receive(_currentValue);
  }

  void _disassociate(_PublishedSubscription<Output> subscription) {  
    _subscriptions.remove(subscription);
  }
}


class _PublishedSubscription<Output> implements Subscription {
  final WeakReference<Published<Output>> _subject;
  final Subscriber<Output, Never> _subscriber;

  _PublishedSubscription(Published<Output> subject, Subscriber<Output, Never> subscriber)
      : _subject = WeakReference(subject),
        _subscriber = subscriber;

  void receive(Output input) {
    _subscriber.receive(input);
  }
  
  void receiveError(Never failure) {
    _subscriber.receiveError(failure);
  }

  void receiveCompletion() {
    _subscriber.receiveCompletion();
  }

  @override
  void cancel() {
    _subject.target?._disassociate(this);
  }
}