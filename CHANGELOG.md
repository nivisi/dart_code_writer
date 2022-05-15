## 0.0.7

Allow to use forceNotRequired when creating a method parameter. Only valid for abstract classes to be able to create method signatures like this:

```dart
// Notice: it is both named and non-nullable, but has no required keyword.
void call({int param});
```

## 0.0.6

- If a method has no implementation (oneLineCall or lines filled) and belongs to an abstract class, its body (e.g. "{}") now is not printed. If it does not belong to an abstract class, writeTo throws exception.

## 0.0.5

- Allow to provide default values for method parameters.

## 0.0.4

- Fix the optional/named parameters problem in method builders.

## 0.0.3

- Add one line call to method builder.

## 0.0.2

- Added const constructors to classes.

## 0.0.1

- Just a quick release with the very base, not refactored and not tested code.
