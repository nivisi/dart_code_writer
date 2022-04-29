part of '../builders.dart';

class GetterBuilder implements BaseBuilder {
  String? _name;
  String? _type;
  bool _isOverriding = false;
  bool _isStatic = false;
  bool _isPrivate = false;
  bool _isNullable = false;
  String? _returns;
  final List<String> _customReturnLines = [];

  GetterBuilder withName(String name) {
    _name = name;
    return this;
  }

  GetterBuilder withType(String type) {
    _type = type;
    return this;
  }

  GetterBuilder get overriding {
    _isOverriding = true;
    return this;
  }

  GetterBuilder get static {
    _isStatic = true;
    return this;
  }

  GetterBuilder get private {
    _isPrivate = true;
    return this;
  }

  GetterBuilder get nullable {
    _isNullable = true;
    return this;
  }

  GetterBuilder returns(String value) {
    if (_customReturnLines.isNotEmpty) {
      throw Exception('custom getter lines cannot be combined with returns');
    }
    _returns = value;
    return this;
  }

  GetterBuilder withCustomGetLine(String value) {
    if (_returns != null) {
      throw Exception('returns cannot be combined with custom getter lines');
    }
    _customReturnLines.add(value);
    return this;
  }

  @override
  void writeTo(StringBuffer buffer) {
    if (_name == null) {
      throw Exception('Getter must have a name');
    }

    DartCodeWriter.writeGetterSignature(
      buffer,
      name: _name!,
      type: _type,
      returns: _returns,
      customReturnLines: _customReturnLines,
      isNullable: _isNullable,
      isOverriding: _isOverriding,
      isPrivate: _isPrivate,
      isStatic: _isStatic,
    );
  }
}
