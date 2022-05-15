part of '../builders.dart';

class MethodBuilder implements BaseBuilder {
  String? _name;
  String? _returnType;

  bool _isOverriding = false;
  bool _isVisibleForTesting = false;
  bool _isProtected = false;
  bool _isNonVirtual = false;
  bool _isStatic = false;
  // TODO: Generate super.call();
  bool _callsSuper = false;
  bool _mustCallSuper = false;
  bool _isPrivate = false;
  String? _customSignature;
  final List<String> _generics = [];
  final List<MethodParameter> _parameters = [];
  final List<String> _lines = [];
  String? _oneLineCall;
  bool _isInAbstractClass = false;

  bool _hasOptional = false;
  bool _hasNamed = false;

  MethodBuilder withCustomSignature(String signature) {
    _customSignature = signature;
    return this;
  }

  MethodBuilder withName(String name) {
    _name = name;
    return this;
  }

  MethodBuilder withReturnType(String type) {
    _returnType = type;
    return this;
  }

  MethodBuilder withGenericType(
    String type, {
    String? thatExtends,
  }) {
    var typeToWrite = type;

    if (thatExtends != null && thatExtends.isNotEmpty) {
      typeToWrite += ' extends $thatExtends';
    }

    _generics.add(typeToWrite);
    return this;
  }

  MethodBuilder withParameter({
    required String name,
    required String type,
  }) {
    _parameters.add(
      MethodParameter(name, type, ParameterType.regular),
    );
    return this;
  }

  MethodBuilder withOptionalParameter({
    required String name,
    required String type,
    String? defaultValue,
  }) {
    if (_hasNamed) {
      throw Exception(
        'An optional parameter was added, but this method already has a named parameter. Using both at the same time is not allowed.',
      );
    }
    _hasOptional = true;
    _parameters.add(
      MethodParameter(
        name,
        type,
        ParameterType.optional,
        defaultValue: defaultValue,
      ),
    );
    return this;
  }

  MethodBuilder withNamedParameter({
    required String name,
    required String type,
    String? defaultValue,
  }) {
    if (_hasOptional) {
      throw Exception(
        'A named parameter was added, but this method already has an optional parameter. Using both at the same time is not allowed.',
      );
    }
    _hasNamed = true;
    _parameters.add(
      MethodParameter(
        name,
        type,
        ParameterType.named,
        defaultValue: defaultValue,
      ),
    );
    return this;
  }

  MethodBuilder get overriding {
    _isOverriding = true;
    return this;
  }

  MethodBuilder get callsSuper {
    if (_isPrivate) {
      throw Exception('A private method cannot call super');
    }
    _callsSuper = true;
    return this;
  }

  MethodBuilder get mustCallSuper {
    if (_isPrivate) {
      throw Exception('A private method cannot call super');
    }
    _mustCallSuper = true;
    return this;
  }

  MethodBuilder get nonVirtual {
    _isNonVirtual = true;
    return this;
  }

  MethodBuilder get protected {
    _isProtected = true;
    return this;
  }

  MethodBuilder get private {
    _isPrivate = true;
    return this;
  }

  MethodBuilder get static {
    _isStatic = true;
    return this;
  }

  MethodBuilder get visibleForTesting {
    _isVisibleForTesting = true;
    return this;
  }

  MethodBuilder get _inAbstractClass {
    _isInAbstractClass = true;
    return this;
  }

  MethodBuilder line(String line) {
    if (_oneLineCall != null) {
      throw Exception('lines cannot be used with one line call ');
    }

    _lines.add(line);
    return this;
  }

  MethodBuilder lines(Iterable<String> lines) {
    if (_oneLineCall != null) {
      throw Exception('lines cannot be used with one line call ');
    }

    var method = this;
    for (final line in lines) {
      method = method.line(line);
    }
    return method;
  }

  MethodBuilder withOneLineCall(String call) {
    if (_lines.isNotEmpty) {
      throw Exception('one line call cannot be used with lines');
    }
    _oneLineCall = call;
    return this;
  }

  @override
  void writeTo(StringBuffer buffer) {
    if (_isOverriding) {
      DartCodeWriter.override(buffer);
    }

    if (_isProtected) {
      DartCodeWriter.protected(buffer);
    }

    if (_isVisibleForTesting) {
      DartCodeWriter.visibleForTesting(buffer);
    }

    if (_isNonVirtual) {
      DartCodeWriter.nonVirtual(buffer);
    }

    if (_mustCallSuper) {
      DartCodeWriter.mustCallSuper(buffer);
    }

    buffer.writeln();

    if (_customSignature != null) {
      buffer.write(_customSignature);
    } else {
      if (_isStatic) {
        buffer.write('static ');
      }

      final typeToWrite = _returnType == null ? 'void' : _returnType.toString();
      final nameToWrite = _isPrivate ? '_$_name' : _name;

      buffer.write('$typeToWrite $nameToWrite');

      if (_generics.isNotEmpty) {
        buffer.write('<${_generics.join(', ')}>');
      }

      buffer.write('(');

      if (_parameters.isEmpty) {
        buffer.write(')');
      } else {
        buffer.writeln();

        final regularParameters =
            _parameters.where((e) => e.isRegular).toList();

        for (final param in regularParameters) {
          DartCodeWriter.writeMethodParameter(
            buffer,
            name: param.name,
            type: param.type,
            parameterType: param.methodParameterType,
          );

          final isLast = regularParameters.last == param;

          if (!isLast) {
            buffer.writeln();
          }
        }

        final optionalParameters = _parameters.where((e) => e.isOptional);

        if (optionalParameters.isNotEmpty) {
          buffer.writeln('[');

          for (final param in optionalParameters) {
            DartCodeWriter.writeMethodParameter(
              buffer,
              name: param.name,
              type: param.type,
              parameterType: param.methodParameterType,
              defaultValue: param.defaultValue,
            );

            final isLast = optionalParameters.last == param;

            if (!isLast) {
              buffer.writeln();
            }
          }

          buffer.write(']');
        }

        final namedParameters = _parameters.where((e) => e.isNamed);

        if (namedParameters.isNotEmpty) {
          buffer.writeln('{');

          for (final param in namedParameters) {
            DartCodeWriter.writeMethodParameter(
              buffer,
              name: param.name,
              type: param.type,
              parameterType: param.methodParameterType,
              defaultValue: param.defaultValue,
            );

            final isLast = namedParameters.last == param;

            if (!isLast) {
              buffer.writeln();
            }
          }

          buffer.write('}');
        }

        buffer.write(')');
      }
    }

    if (_oneLineCall != null) {
      final endOfLine = _oneLineCall!.endsWith(';') ? '' : ';';
      buffer.write('=> $_oneLineCall$endOfLine');

      return;
    }

    if (_lines.isEmpty) {
      if (_isInAbstractClass) {
        buffer.write(';');
        return;
      }

      throw Exception(
        'The method is not in an abstract class, but has no implementation (lines and oneLineCall are both null)',
      );
    }

    buffer.writeln('{');
    for (final line in _lines) {
      buffer.writeln('  $line');
    }

    buffer.write('}');
  }
}
