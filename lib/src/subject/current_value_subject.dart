import 'package:dart_combine/dart_combine.dart';

class CurrentValueSubject<Output, Failure extends Error> extends Publisher<Output, Failure> {
  final List<_CurrentValueSubjectSubscription<Output, Failure>> _subscriptions = [];

  Output _currentValue;

  Output get value => _currentValue;
  
  set value(Output value) => send(value);

  CurrentValueSubject(Output initialValue) : _currentValue = initialValue;

  void send(Output value) {
    this._currentValue = value;
    for (final subscription in _subscriptions) {
      subscription.receive(value);
    }
  }

  void sendError(Failure failure) {
    for (final subscription in _subscriptions) {
      subscription.receiveError(failure);
    }

    _subscriptions.clear();
  }

  void sendCompletion() {
    for (final subscription in _subscriptions) {
      subscription.receiveCompletion();
    }

    _subscriptions.clear();
  }

  @override
  void receive(Subscriber<Output, Failure> subscriber) {
    final subscription = _CurrentValueSubjectSubscription(this, subscriber);
    subscriber.receiveSubscription(subscription);
    _subscriptions.add(subscription);
    subscriber.receive(_currentValue);
  }

  void _disassociate(_CurrentValueSubjectSubscription<Output, Failure> subscription) {  
    _subscriptions.remove(subscription);
  }
}


class _CurrentValueSubjectSubscription<Output, Failure extends Error> implements Subscription {
  final WeakReference<CurrentValueSubject<Output, Failure>> _subject;
  final Subscriber<Output, Failure> _subscriber;

  _CurrentValueSubjectSubscription(CurrentValueSubject<Output, Failure> subject, Subscriber<Output, Failure> subscriber)
      : _subject = WeakReference(subject),
        _subscriber = subscriber;

  void receive(Output input) {
    _subscriber.receive(input);
  }
  
  void receiveError(Failure failure) {
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
