# Dart Combine

A simple copy implementation of Swift Combine Framework implemented in Dart.

## Features

Unlike Dart's `Stream<T>`, value changes are made synchronously. This allows you to create Blocs without flickering the screen.

## Example

### map

```dart
import 'package:dart_combine/dart_combine.dart';

void main() {
  final subject = CurrentValueSubject<int, Never>(1);

  final cancellable = subject
    .map((e) => e * 2)
    .sink({ value in
      print(value);
    }); // 2

  subject.send(10); // 20
}
```

### filter (unimplemented)

```dart
import 'package:dart_combine/dart_combine.dart';

void main() {
  final subject = CurrentValueSubject<int, Never>(1);

  final cancellable = subject
    .filter((e) => e % 2 == 0)
    .sink({ value in
      print(value);
    }); // 2

  subject.send(10); // 10
  subject.send(11); // 10
}
```

### Just

```dart
import 'package:dart_combine/dart_combine.dart';

void main() {
  final cancellable = Just(1)
    .sink({ value in
      print(value);
    }); // 1
}
```

### combineLatest (for Iterable)

```dart 
import 'package:dart_combine/dart_combine.dart';

void main() {
  final subject1 = CurrentValueSubject<int, Never>(1);
  final subject2 = CurrentValueSubject<int, Never>(2);

  final cancellable = [subject1, subject2].combineLatest()
    .sink({ value in
      print(value)
    }); // [1, 2]

  subject1.send(10); // [10, 2]
  subject2.send(20); // [10, 20]
}
```

### CombineLatest2/3

```dart
import 'package:dart_combine/dart_combine.dart';

void main() {
  final subject1 = CurrentValueSubject<int, Never>(1);
  final subject2 = CurrentValueSubject<int, Never>(2);

  final cancellable = subject1.combineLatest2(subject2)
    .map((e) => e.$0 + e.$1)
    .sink({ value in
      print(value);
    }); // 3

  subject1.send(10); // 12
  subject2.send(20); // 30
}
```