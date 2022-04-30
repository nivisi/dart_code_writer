part of '../builders.dart';

class ClassBuilder implements BaseBuilder {
  String? _name;
  bool _isAbstract = false;
  bool _isConstConstructor = false;
  final List<String> _implements = [];
  String? _extends;
  final List<String> _with = [];
  final List<String> _annotations = [];
  final List<MethodBuilder> _methods = [];
  final List<FieldBuilder> _fields = [];
  final List<GetterBuilder> _getters = [];
  final List<SetterBuilder> _setters = [];

  ClassBuilder withName(String name) {
    _name = name;
    return this;
  }

  ClassBuilder get withConstConstructor {
    _isConstConstructor = true;
    return this;
  }

  ClassBuilder get abstract {
    _isAbstract = true;
    return this;
  }

  ClassBuilder withMixin(String mixin) {
    _with.add(mixin);
    return this;
  }

  ClassBuilder implements(String implements) {
    _implements.add(implements);
    return this;
  }

  ClassBuilder extendsClass(String className) {
    _extends = className;
    return this;
  }

  ClassBuilder withField(FieldBuilder field) {
    _fields.add(field);
    return this;
  }

  ClassBuilder withMethod(MethodBuilder method) {
    _methods.add(method);
    return this;
  }

  ClassBuilder withGetter(GetterBuilder getter) {
    _getters.add(getter);
    return this;
  }

  ClassBuilder withSetter(SetterBuilder setter) {
    _setters.add(setter);
    return this;
  }

  ClassBuilder withAnnotation(String annotation) {
    _annotations.add(annotation);
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

    DartCodeWriter.writeClassHeader(
      buffer,
      name: _name!,
      isAbstract: _isAbstract,
      extendsClass: _extends,
      implements: _implements,
      mixins: _with,
    );

    buffer.writeln('{');

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

    final finalFields = _fields.where(((element) => element._isFinal));
    final constStr = _isConstConstructor ? 'const ' : '';

    if (finalFields.isEmpty) {
      buffer.write('  ');
      buffer.writeln('$constStr$_name();');
    } else {
      buffer.write('  ');
      buffer.writeln('$constStr$_name(');

      final privateFinalFields =
          finalFields.where((element) => element._isPrivate);
      final publicFinalFields =
          finalFields.where((element) => !element._isPrivate);

      for (final field in privateFinalFields) {
        buffer.write('  ');
        DartCodeWriter.writeConstructorParameter(
          buffer,
          name: field._name!,
          isPrivate: true,
          isNullable: field._isNullable,
        );
      }

      if (publicFinalFields.isNotEmpty) {
        buffer.writeln('  {');
        for (final field in publicFinalFields) {
          DartCodeWriter.writeConstructorParameter(
            buffer,
            name: field._name!,
            isPrivate: false,
            isNullable: field._isNullable,
            asNamed: true,
          );
        }
        buffer.writeln('  });');
      } else {
        buffer.writeln('  );');
      }

      buffer.writeln();
    }

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
