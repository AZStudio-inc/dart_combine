import 'package:dart_combine/dart_combine.dart';

final class PassthroughSubject<Output, Failure extends Error> extends Publisher<Output, Failure> {
  final List<_PassthroughSubjectSubscription<Output, Failure>> _subscriptions = [];

  void send(Output value) {
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
    final subscription = _PassthroughSubjectSubscription(this, subscriber);
    subscriber.receiveSubscription(subscription);
    _subscriptions.add(subscription);
  }

  void _disassociate(_PassthroughSubjectSubscription<Output, Failure> subscription) {  
    _subscriptions.remove(subscription);
  }
}

class _PassthroughSubjectSubscription<Output, Failure extends Error> implements Subscription {
  final WeakReference<PassthroughSubject<Output, Failure>> _subject;
  final Subscriber<Output, Failure> _subscriber;

  _PassthroughSubjectSubscription(PassthroughSubject<Output, Failure> subject, Subscriber<Output, Failure> subscriber)
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
