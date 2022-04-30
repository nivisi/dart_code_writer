part of '../builders.dart';

class MethodParameter {
  final String name;
  final String type;
  final MethodParameterType methodType;

  MethodParameter(this.name, this.type, this.methodType);

  bool get isRegular => methodType == MethodParameterType.regular;
  bool get isNamed => methodType == MethodParameterType.named;
  bool get isOptional => methodType == MethodParameterType.optional;
}
