part of '../builders.dart';

class MethodParameter {
  final String name;
  final String type;
  final ParameterType methodType;

  MethodParameter(this.name, this.type, this.methodType);

  bool get isRegular => methodType == ParameterType.regular;
  bool get isNamed => methodType == ParameterType.named;
  bool get isOptional => methodType == ParameterType.optional;
}
