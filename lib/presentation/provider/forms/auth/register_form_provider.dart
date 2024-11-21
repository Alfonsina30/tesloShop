import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../../presentation/provider/auth/auth_provider.dart';
import '../../../../infrastructure/infrastructure.dart';

//! 3 - StateNotifierProvider - consume afuera
///--> autoDispose detroy the state of a provider
final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
//---> registerUserAuth call authProvider who call the repository that call Datasource for registerUser 
  final registerUserAuth = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerUserAuth: registerUserAuth);
});

//! 2 - Como implementamos un notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(
      {required String email,
      required String password,
      required String fullName}) registerUserAuth;

  RegisterFormNotifier({required this.registerUserAuth})
      : super(RegisterFormState());

  onFullNameChange(String value) {
    final fullName = FullName.dirty(value);
    state = state.copyWith(
        fullName: fullName,
        isValid: Formz.validate(
            [fullName, state.email, state.password, state.repeatPassword]));
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail,
        isValid: Formz.validate(
            [newEmail, state.fullName, state.password, state.repeatPassword]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);

    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate(
            [newPassword, state.fullName, state.email, state.repeatPassword]));
  }

  onPasswordRepeatChanged(String value) {
    final newPassword = PasswordRepeat.dirty(value);

    state = state.copyWith(
        repeatPassword: newPassword,
        isValid: Formz.validate(
            [newPassword, state.fullName, state.email, state.password]));
  }


  onFormSubmitRegister() async {
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    ///---> call API function
    await registerUserAuth(
      fullName: state.fullName.value,
      email: state.email.value,
      password: state.password.value,
    );

    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final fullName = FullName.dirty(state.fullName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final passwordRepeat = PasswordRepeat.dirty(state.repeatPassword.value);

    state = state.copyWith(
        isFormPosted: true,
        fullName: fullName,
        email: email,
        password: password,
        repeatPassword: passwordRepeat,
        isValid: Formz.validate([fullName, email, password, passwordRepeat]));
  }
}

//! 1 - State del provider
class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final FullName fullName;
  final Email email;
  final Password password;
  final PasswordRepeat repeatPassword;

  RegisterFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.fullName = const FullName.pure(),
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.repeatPassword = const PasswordRepeat.pure()});

  RegisterFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          FullName? fullName,
          Email? email,
          Password? password,
          PasswordRepeat? repeatPassword}) =>
      RegisterFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          fullName: fullName ?? this.fullName,
          email: email ?? this.email,
          password: password ?? this.password,
          repeatPassword: repeatPassword ?? this.repeatPassword);

  @override
  String toString() {
    return '''
  LoginFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    fullName: $fullName
    email: $email
    password: $password
    repeatPassword: $repeatPassword
''';
  }
}
