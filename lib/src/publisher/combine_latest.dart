
import 'package:dart_combine/dart_combine.dart';

extension PubilsherCombineLatestCollectionExtension<Element, Failure extends Error> on Iterable<Publisher<Element, Failure>> {
  Publisher<List<Element>, Failure> combineLatest({
    bool handleEmpty = true,
  }) {
    if (this.isEmpty && handleEmpty) {
      return Just([]);
    }
    return CombineLatestCollection(publishers: this); 
  }
}

final class CombineLatestCollection<Element, Failure extends Error> implements Publisher<List<Element>, Failure> {
  final Iterable<Publisher<Element, Failure>> _publishers;

  CombineLatestCollection({
    required Iterable<Publisher<Element, Failure>> publishers,
  }) : _publishers = publishers;

  @override
  void receive(Subscriber<List<Element>, Failure> subscriber) {
    final inner = _CombineLatestCollectionInner(subscriber, _publishers.length);

    for (var i = 0; i < _publishers.length; i++) {
      final publisher = _publishers.elementAt(i);
      publisher.map((e) => (i, e)).receive(inner);
    }
  }
}

final class _CombineLatestCollectionInner<Element, Failure extends Error> implements Subscriber<(int, Element), Failure> {

  final List<Element?> _prebuildList;

  List<Element>? _latestValues;

  final List<bool> _hasReceived;

  int _receivedCount = 0;

  int _completedCount = 0;

  final int _length;

  final Subscriber<List<Element>, Failure> _downstream;
  
  _CombineLatestCollectionInner(
    Subscriber<List<Element>, Failure> downstream,
    int length,
  ) : _length = length,
      _latestValues = null,
      _prebuildList = List.filled(length, null),
      _hasReceived = List.filled(length, false),
      _downstream = downstream;
  
  @override
  void receive((int, Element) input) {
    if (_latestValues != null) {
      _latestValues![input.$1] = input.$2;
      this._downstream.receive(_latestValues!);
    } else {
      _prebuildList[input.$1] = input.$2;
      if (!_hasReceived[input.$1]) {
        _hasReceived[input.$1] = true;
        _receivedCount += 1;
      }
      if (_receivedCount == _length) {
        _latestValues = _prebuildList.whereType<Element>().toList();
        assert(_latestValues!.length == _length, 'Received values must be of type Element');
        this._downstream.receive(_latestValues!);
      }
    }
  }

  @override
  void receiveError(Failure failure) {
    _downstream.receiveError(failure);
  }

  @override
  void receiveCompletion() {
    _completedCount += 1;
    if (_completedCount == _length) {
      _downstream.receiveCompletion();
    }
  }
  
  @override
  void receiveSubscription(Subscription subscription) {
    _downstream.receiveSubscription(subscription);
  }
}