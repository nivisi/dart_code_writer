import 'builders/builders.dart';
import 'exceptions/name_must_be_set.dart';

mixin rofl {}

class Something extends Object
    with rofl
    implements Exception, NameMustBeSetException {}

class DartCodeWriter {
  const DartCodeWriter._();

  static MethodBuilder get createMethod => MethodBuilder();
  static FieldBuilder get createField => FieldBuilder();
  static ClassBuilder get createClass => ClassBuilder();
  static MixinBuilder get createMixin => MixinBuilder();
  static ExtensionBuilder get createExtension => ExtensionBuilder();
  static GetterBuilder get createGetter => GetterBuilder();
  static SetterBuilder get createSetter => SetterBuilder();

  static void static(StringBuffer buffer) => buffer.writeln(('late'));
  static void late(StringBuffer buffer) => buffer.writeln(('late'));
  static void final_(StringBuffer buffer) => buffer.writeln(('final'));
  static void equals(StringBuffer buffer) => buffer.writeln((' = '));
  static void override(StringBuffer buffer) => buffer.writeln(('@override'));
  static void protected(StringBuffer buffer) => buffer.writeln(('@protected'));

  static void visibleForTesting(StringBuffer buffer) =>
      buffer.writeln(('@visibleForTesting'));

  static void nonVirtual(StringBuffer buffer) =>
      buffer.writeln(('@nonVirtual'));

  static void mustCallSuper(StringBuffer buffer) =>
      buffer.writeln(('@mustCallSuper'));

  static void writeClassHeader(
    StringBuffer buffer, {
    required String name,
    bool isAbstract = false,
    List<String>? implements,
    String? extendsClass,
    List<String>? mixins,
  }) {
    if (name.isEmpty) {
      throw Exception('Name must not be empty');
    }

    if (isAbstract) {
      buffer.write('abstract ');
    }

    buffer.write('class $name ');

    if (extendsClass != null) {
      buffer.write('extends $extendsClass ');
    }

    if (mixins != null && mixins.isNotEmpty) {
      buffer.write('with ${mixins.join(', ')} ');
    }

    if (implements != null && implements.isNotEmpty) {
      buffer.write('implements ${implements.join(', ')} ');
    }
  }

  static void writeMixinHeader(
    StringBuffer buffer, {
    required String name,
    String? on,
  }) {
    if (name.isEmpty) {
      throw Exception('Name must not be empty');
    }

    buffer.write('mixin ');
    buffer.write('$name ');

    if (on != null) {
      buffer.write('on $on');
    }
  }

  static void writeExtensionHeader(
    StringBuffer buffer, {
    required String name,
    required String on,
  }) {
    if (name.isEmpty) {
      throw Exception('Name must not be empty');
    }
    if (on.isEmpty) {
      throw Exception('On must not be empty');
    }

    buffer.write('extension $name on $on');
  }

  static void writeFieldSignature(
    StringBuffer buffer, {
    required String name,
    String? type,
    bool isStatic = false,
    bool isFinal = false,
    bool isLate = false,
    bool isPrivate = false,
    bool isNullable = false,
    bool isOverriding = false,
    String? defaultValue,
  }) {
    if (isOverriding) {
      buffer.writeln('@override');
    }

    if (isStatic) {
      buffer.write('static ');
    }

    if (isLate) {
      buffer.write('late ');
    }

    if (isFinal) {
      buffer.write('final  ');
    }

    if (type != null) {
      final typeToWrite = !isNullable
          ? type
          : type.contains('?')
              ? type
              : '$type?';

      buffer.write('$typeToWrite ');
    }

    final nameToWrite = !isPrivate
        ? name
        : name.startsWith('_')
            ? name
            : '_$name';

    buffer.write(nameToWrite);

    if (defaultValue != null) {
      buffer.write(' = $defaultValue');
    }

    buffer.write(';');
  }

  static void writeGetterSignature(
    StringBuffer buffer, {
    required String name,
    String? type,
    bool isStatic = false,
    bool isPrivate = false,
    bool isNullable = false,
    bool isOverriding = false,
    String? returns,
    List<String>? customReturnLines,
  }) {
    if (isOverriding) {
      buffer.writeln('@override');
    }

    if (isStatic) {
      buffer.write('static ');
    }

    if (type != null) {
      final typeToWrite = !isNullable
          ? type
          : type.contains('?')
              ? type
              : '$type?';

      buffer.write('$typeToWrite ');
    }

    buffer.write('get ');

    final nameToWrite = !isPrivate
        ? name
        : name.startsWith('_')
            ? name
            : '_$name';

    buffer.write(nameToWrite);

    if (returns != null) {
      buffer.write(' => $returns');
      if (!returns.endsWith(';')) {
        buffer.write(';');
      }
    } else if (customReturnLines != null) {
      buffer.writeln('{');
      buffer.writeln(customReturnLines.join('\n'));
      buffer.writeln('}');
    } else {
      buffer.write(';');
    }
  }

  static void writeSetterSignature(
    StringBuffer buffer, {
    required String name,
    required String paramName,
    String? paramType,
    bool isStatic = false,
    bool isPrivate = false,
    bool isOverriding = false,
    String? sets,
    List<String>? customSetLines,
  }) {
    if (isOverriding) {
      buffer.writeln('@override');
    }

    if (isStatic) {
      buffer.write('static ');
    }

    buffer.write('set ');

    final nameToWrite = !isPrivate
        ? name
        : name.startsWith('_')
            ? name
            : '_$name';

    buffer.write('$nameToWrite(');
    if (paramType != null) {
      buffer.write('$paramType ');
    }
    buffer.write('$paramName ');

    buffer.write(')');

    if (sets != null) {
      buffer.write(' => $sets');
      if (!sets.endsWith(';')) {
        buffer.write(';');
      }
    } else if (customSetLines != null) {
      buffer.writeln('{');
      buffer.writeln(customSetLines.join('\n'));
      buffer.writeln('}');
    } else {
      buffer.write(';');
    }
  }

  // set sth(int p)

  static void writeMethodSignature(
    StringBuffer buffer, {
    required String name,
    String? returningType,
    bool isStatic = false,
    bool isPrivate = false,
    bool isProtected = false,
    bool isOverriding = false,
    bool annotateWithMustCallSuper = false,
  }) {
    if (isProtected) {
      buffer.writeln('@protected');
    }

    if (isOverriding) {
      buffer.writeln('@override');
    }

    if (annotateWithMustCallSuper) {
      buffer.writeln('@mustCallSuper');
    }

    if (isStatic) {
      buffer.write('static ');
    }

    if (returningType != null) {
      buffer.write('$returningType ');
    }

    final nameToWrite = !isPrivate
        ? name
        : name.startsWith('_')
            ? name
            : '_$name';

    buffer.write('$nameToWrite ');
  }

  static void writeConstructorParameter(
    StringBuffer buffer, {
    required String name,
    bool isNullable = false,
    bool isPrivate = false,
    bool asNamed = false,
  }) {
    if (isPrivate) {
      final nameToWrite = name.startsWith('_') ? name : '_$name';

      buffer.writeln('  this.$nameToWrite,');
      return;
    }

    if (!asNamed) {
      buffer.writeln('  this.$name,');
      return;
    }

    buffer.write('  ');
    if (!isNullable) {
      buffer.write('required ');
    }

    buffer.writeln('this.$name,');
  }

  static void writeMethodParameter(
    StringBuffer buffer, {
    required String name,
    String? type,
    ParameterType parameterType = ParameterType.regular,
  }) {
    if (name.isEmpty) {
      throw Exception('Name must not be empty');
    }

    buffer.write('  ');

    if (parameterType == ParameterType.regular) {
      if (type != null) {
        buffer.write(type);
      }

      buffer.write(' $name,');

      return;
    }

    if (parameterType == ParameterType.optional) {
      if (type != null) {
        buffer.write('$type ');
      }
      buffer.write(name);
      return;
    }

    if (type != null) {
      if (type.contains('?')) {
        buffer.write('$type ');
      } else {
        buffer.write('required $type ');
      }
    }

    buffer.write('$name,');
  }
}
