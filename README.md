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
    .sink((value) {
      print(value);
    }); // 2

  subject.send(10); // 20
}
```

### filter

```dart
import 'package:dart_combine/dart_combine.dart';

void main() {
  final subject = CurrentValueSubject<int, Never>(1);

  final cancellable = subject
    .filter((e) => e % 2 == 0)
    .sink((value) {
      print(value);
    }); // 2

  subject.send(10); // 10
  subject.send(11); // 10
}
```

### Just / Empty / Fail

```dart
import 'package:dart_combine/dart_combine.dart';

void main() { // Just
  final cancellable = Just(1)
    .sink((value) {
      print(value);
    }); // 1
}

void main() { // Empty
  final cancellable = Empty<void>()
    .sink((value) {
      print(value);
    }); // Never
}

void main() { // Fail
  final cancellable = Fail<Error>(Exception('error'))
    .sink((value) {
      print(value);
    }, onReceiveError: (error) {
      print(error);
    }); // Exception: error
}
```

### CombineLatest2/3/4

```dart
import 'package:dart_combine/dart_combine.dart';

void main() {
  final subject1 = CurrentValueSubject<int, Never>(1);
  final subject2 = CurrentValueSubject<int, Never>(2);

  final cancellable = subject1
    .combineLatest2(subject2, (a, b) => a + b)
    .sink((value) {
      print(value);
    }); // 3

  subject1.send(10); // 12
  subject2.send(20); // 30
}
```

### combineLatest (for Iterable)

```dart 
import 'package:dart_combine/dart_combine.dart';

void main() {
  final subject1 = CurrentValueSubject<int, Never>(1);
  final subject2 = CurrentValueSubject<int, Never>(2);

  final cancellable = [subject1, subject2]
    .combineLatest(
      handleEmpty: true // if true, emit empty list when any of the subjects are empty
    )
    .sink((value) {
      print(value)
    }); // [1, 2]

  subject1.send(10); // [10, 2]
  subject2.send(20); // [10, 20]
}
```

### switchMap

```dart
import 'package:dart_combine/dart_combine.dart';

void main() {
  final subject = CurrentValueSubject<Publisher<int>, Never>(Just(1));

  final cancellable = subject
    .switchMap((e) => e)
    .sink((value) {
      print(value);
    }); // 1

  subject.send(Just(10)); // 10
}
```

### Published

Same as `CurrentValueSubject` but with a Never for the error type.

```dart
import 'package:dart_combine/dart_combine.dart';

class ViewModel {
  final name = Published<String>("Alice");

  final age = Published<int>(20);
}

extension ViewModelEditor on ViewModel {
  void updateName(String name) {
    this.name.send(name);
  }

  void updateAge(int age) {
    this.age.send(age);
  }
}

void main() {
  final viewModel = ViewModel();

  final cancellable = viewModel.name
    .sink((value) {
      print(value);
    }); // Alice

  viewModel.value = "Bob"; // Bob
}
```
