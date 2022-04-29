import '../lib/src/dart_code_writer.dart';

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
      // .private
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

  DartCodeWriter.createExtension
      .withName('MyControllerExtension')
      .on('BuildContext')
      .withMethod(watchMethod)
      .writeTo(buffer);

  print(buffer.toString());
}
