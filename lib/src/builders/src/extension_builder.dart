part of '../builders.dart';

extension F on String {}

class ExtensionBuilder implements BaseBuilder {
  String? _name;
  String? _on;
  List<MethodBuilder> _methods = [];

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

    final publicMethods = _methods.where((element) => !element._isPrivate);

    for (final method in publicMethods) {
      method.writeTo(buffer);
      buffer.writeln();
    }

    buffer.writeln('}');
  }
}
