import 'package:formz/formz.dart';

// Define input validation errors
enum PasswordRepeatError { empty, length, format }

// Extend FormzInput and provide the input type and error type.
class PasswordRepeat extends FormzInput<String, PasswordRepeatError> {


  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  // Call super.pure to represent an unmodified form input.
  const PasswordRepeat.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const PasswordRepeat.dirty( String value ) : super.dirty(value);


  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == PasswordRepeatError.empty ) return 'The field is required';
    if ( displayError == PasswordRepeatError.length ) return 'Minimum 6 characters';
    if ( displayError == PasswordRepeatError.format ) return 'It must have a capital letter, letters and a number';

    return null;
  }


  // Override validator to handle validating a given input value.
  @override
  PasswordRepeatError? validator(String value) {

    if ( value.isEmpty || value.trim().isEmpty ) return PasswordRepeatError.empty;
    if ( value.length < 6 ) return PasswordRepeatError.length;
    if ( !passwordRegExp.hasMatch(value) ) return PasswordRepeatError.format;

    return null;
  }
}