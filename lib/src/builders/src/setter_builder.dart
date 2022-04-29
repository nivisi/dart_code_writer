part of '../builders.dart';

class SetterBuilder implements BaseBuilder {
  String? _name;
  String? _paramName;
  String? _paramType;
  bool _isOverriding = false;
  bool _isStatic = false;
  bool _isPrivate = false;
  String? _sets;
  final List<String> _customSetLines = [];

  SetterBuilder withName(String name) {
    _name = name;
    return this;
  }

  SetterBuilder withParameterType(String type) {
    _paramType = type;
    return this;
  }

  SetterBuilder withParameterName(String name) {
    _paramName = name;
    return this;
  }

  SetterBuilder get overriding {
    _isOverriding = true;
    return this;
  }

  SetterBuilder get static {
    _isStatic = true;
    return this;
  }

  SetterBuilder get private {
    _isPrivate = true;
    return this;
  }

  SetterBuilder sets({required String field, required String to}) {
    if (_customSetLines.isNotEmpty) {
      throw Exception('sets cannot be combined with custom setter lines');
    }
    _sets = '$field = $to';
    return this;
  }

  SetterBuilder withCustomSetLine(String value) {
    if (_sets != null) {
      throw Exception('custom setter lines cannot be combined with sets');
    }
    _customSetLines.add(value);
    return this;
  }

  @override
  void writeTo(StringBuffer buffer) {
    if (_name == null) {
      throw Exception('Setter must have a name');
    }

    if (_paramName == null) {
      throw Exception('Setter parameter must have a name');
    }

    DartCodeWriter.writeSetterSignature(
      buffer,
      name: _name!,
      paramName: _paramName!,
      paramType: _paramType,
      sets: _sets,
      customSetLines: _customSetLines,
      isOverriding: _isOverriding,
      isPrivate: _isPrivate,
      isStatic: _isStatic,
    );
  }
}
