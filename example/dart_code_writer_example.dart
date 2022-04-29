import 'package:dart_code_writer/src/dart_code_writer.dart';

void main() {
  StringBuffer buffer = StringBuffer();

  final nameField = DartCodeWriter.createField
      .withName('name')
      .withType('String')
      .overriding
      .static
      .late
      .final_
      .nullable
      .private;

  final publicNameField = DartCodeWriter.createField
      .withName('name')
      .withType('String')
      .overriding
      .static
      .late
      .final_;

  final updateNameMethod = DartCodeWriter.createMethod
      .withName('name')
      .withReturnType('String')
      .static
      .nonVirtual
      .overriding
      .callsSuper
      .protected
      .mustCallSuper
      .line('final newName = "Privet";')
      .line('return newName;');

  DartCodeWriter.createMixin
      .withName('MyCoolMixin')
      .on('AnotherCoolClass')
      .withField(publicNameField)
      .withField(nameField)
      .withMethod(updateNameMethod)
      .writeTo(buffer);

  buffer.writeln();
  buffer.writeln();
  buffer.writeln();
  buffer.writeln();

  DartCodeWriter.createClass.abstract
      .withName('Hello')
      .extendsClass('OtherHello')
      .implements('Sth')
      .implements('Sth2')
      .withMixin('CoolMixin')
      .withMixin('CoolMixin2')
      .withAnnotation('@xControllable')
      .withField(nameField)
      .withField(publicNameField)
      .withMethod(updateNameMethod)
      .writeTo(buffer);

  buffer.writeln();
  buffer.writeln();
  buffer.writeln();
  buffer.writeln();

  final watchMethod = DartCodeWriter.createMethod
      .withName('watch')
      .withReturnType('TValue')
      .withGenericType('TClass', thatExtends: 'MyClass')
      .withGenericType('TValue')
      .withParameter(name: 'Hello', type: 'String')
      .line(
        'return this.select((MyController controller) => controller.value);',
      );

  final someGetter = DartCodeWriter.createGetter
      .withName('some')
      .withType('myType')
      .returns('"HELLO!"');

  final customLines = DartCodeWriter.createGetter
      .withName('customLines')
      .withType('myType')
      .withCustomGetLine('var r = "privet";')
      .withCustomGetLine('return r;');

  final someSetter = DartCodeWriter.createSetter
      .withName('some')
      .private
      .withParameterName('param')
      .withParameterType('int')
      .sets(field: 'other', to: 'this');

  final setterCustomLines = DartCodeWriter.createSetter
      .withName('customLines')
      .withParameterName('param')
      .withParameterType('int')
      .withCustomSetLine('var something = 10;')
      .withCustomSetLine('return something;');

  DartCodeWriter.createExtension
      .withName('MyControllerExtension')
      .on('BuildContext')
      .withMethod(watchMethod)
      .withGetter(customLines)
      .withGetter(someGetter)
      .withSetter(someSetter)
      .withSetter(setterCustomLines)
      .writeTo(buffer);

  print(buffer.toString());
}
