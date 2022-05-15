part of '../builders.dart';

class MethodParameter {
  final String name;
  final String type;
  final ParameterType methodParameterType;
  final String? defaultValue;

  const MethodParameter(
    this.name,
    this.type,
    this.methodParameterType, {
    this.defaultValue,
  }) : assert(
          defaultValue == null || methodParameterType != ParameterType.regular,
          'Only named or optional params can have a default value',
        );

  bool get isRegular => methodParameterType == ParameterType.regular;
  bool get isNamed => methodParameterType == ParameterType.named;
  bool get isOptional => methodParameterType == ParameterType.optional;
}
