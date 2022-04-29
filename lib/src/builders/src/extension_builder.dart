part of '../builders.dart';

extension F on String {}

class ExtensionBuilder implements BaseBuilder {
  String? _name;
  String? _on;
  final List<MethodBuilder> _methods = [];
  final List<GetterBuilder> _getters = [];
  final List<SetterBuilder> _setters = [];

  ExtensionBuilder withName(String name) {
    _name = name;
    return this;
  }

  ExtensionBuilder on(String on) {
    _on = on;
    return this;
  }

  ExtensionBuilder withMethod(MethodBuilder method) {
    _methods.add(method);
    return this;
  }

  ExtensionBuilder withGetter(GetterBuilder getter) {
    _getters.add(getter);
    return this;
  }

  ExtensionBuilder withSetter(SetterBuilder setter) {
    _setters.add(setter);
    return this;
  }

  @override
  void writeTo(StringBuffer buffer) {
    if (_name == null) {
      throw NameMustBeSetException();
    }
    if (_on == null) {
      throw NameMustBeSetException();
    }

    DartCodeWriter.writeExtensionHeader(
      buffer,
      name: _name!,
      on: _on!,
    );

    buffer.writeln(' {');

    final privateGetters = _getters.where((element) => element._isPrivate);
    for (final getter in privateGetters) {
      getter.writeTo(buffer);
      buffer.writeln();
    }

    final privateSetters = _setters.where((element) => element._isPrivate);
    for (final setter in privateSetters) {
      setter.writeTo(buffer);
      buffer.writeln();
    }

    final publicGetters = _getters.where((element) => !element._isPrivate);
    for (final getter in publicGetters) {
      getter.writeTo(buffer);
      buffer.writeln();
    }

    final publicSetters = _setters.where((element) => !element._isPrivate);
    for (final setter in publicSetters) {
      setter.writeTo(buffer);
      buffer.writeln();
    }

    final privateMethods = _methods.where((element) => element._isPrivate);

    for (final method in privateMethods) {
      method.writeTo(buffer);
      buffer.writeln();
    }

    final publicMethods = _methods.where((element) => !element._isPrivate);

    for (final method in publicMethods) {
      method.writeTo(buffer);
      buffer.writeln();
    }

    buffer.writeln('}');
  }
}
