part of '../builders.dart';

class MixinBuilder implements BaseBuilder {
  String? _name;
  String? _on;
  final List<String> _annotations = [];
  final List<MethodBuilder> _methods = [];
  final List<FieldBuilder> _fields = [];
  final List<GetterBuilder> _getters = [];
  final List<SetterBuilder> _setters = [];

  MixinBuilder withName(String name) {
    _name = name;
    return this;
  }

  MixinBuilder on(String on) {
    _on = on;
    return this;
  }

  MixinBuilder withAnnotation(String annotation) {
    _annotations.add(annotation);
    return this;
  }

  MixinBuilder withField(FieldBuilder field) {
    _fields.add(field);
    return this;
  }

  MixinBuilder withMethod(MethodBuilder method) {
    _methods.add(method);
    return this;
  }

  MixinBuilder withGetter(GetterBuilder getter) {
    _getters.add(getter);
    return this;
  }

  MixinBuilder withSetter(SetterBuilder setter) {
    _setters.add(setter);
    return this;
  }

  @override
  void writeTo(StringBuffer buffer) {
    if (_name == null) {
      throw NameMustBeSetException();
    }

    for (final annotation in _annotations) {
      buffer.writeln(annotation);
    }

    DartCodeWriter.writeMixinHeader(
      buffer,
      name: _name!,
      on: _on,
    );

    buffer.writeln(' {');

    final privateFields = _fields.where((element) => element._isPrivate);
    final publicFields = _fields.where((element) => !element._isPrivate);

    for (final field in privateFields) {
      buffer.write('  ');
      field.writeTo(buffer);
      buffer.writeln();
    }

    for (final field in publicFields) {
      buffer.write('  ');
      field.writeTo(buffer);
      buffer.writeln();
    }

    buffer.writeln();

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

    buffer.writeln();

    final privateMethods = _methods.where((element) => element._isPrivate);
    final publicMethods = _methods.where((element) => !element._isPrivate);

    for (final method in privateMethods) {
      method.writeTo(buffer);
      buffer.writeln();
    }

    for (final method in publicMethods) {
      method.writeTo(buffer);
      buffer.writeln();
    }

    buffer.writeln('}');
  }
}
