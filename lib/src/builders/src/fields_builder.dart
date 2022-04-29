part of '../builders.dart';

class FieldBuilder implements BaseBuilder {
  String? _name;
  String? _type;
  bool _isOverriding = false;
  bool _isStatic = false;
  bool _isLate = false;
  bool _isFinal = false;
  bool _isPrivate = false;
  bool _isNullable = false;
  String? _defaultValue;

  FieldBuilder withName(String name) {
    _name = name;
    return this;
  }

  FieldBuilder withType(String type) {
    _type = type;
    return this;
  }

  FieldBuilder get overriding {
    _isOverriding = true;
    return this;
  }

  FieldBuilder get static {
    _isStatic = true;
    return this;
  }

  FieldBuilder get late {
    _isLate = true;
    return this;
  }

  FieldBuilder get final_ {
    _isFinal = true;
    return this;
  }

  FieldBuilder get private {
    _isPrivate = true;
    return this;
  }

  FieldBuilder get nullable {
    _isNullable = true;
    return this;
  }

  FieldBuilder defaultValue(String value) {
    _defaultValue = value;
    return this;
  }

  @override
  void writeTo(StringBuffer buffer) {
    if (_name == null) {
      throw Exception('Field must have a name');
    }

    DartCodeWriter.writeFieldSignature(
      buffer,
      name: _name!,
      type: _type,
      defaultValue: _defaultValue,
      isFinal: _isFinal,
      isLate: _isLate,
      isNullable: _isNullable,
      isOverriding: _isOverriding,
      isPrivate: _isPrivate,
      isStatic: _isStatic,
    );
  }
}
