import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../presentation/provider/forms/auth/register_form_provider.dart';
import '../../../presentation/widgets/shared/shared.dart';
import '../../provider/auth/auth_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
              child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        if (!context.canPop()) return;
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back_rounded,
                          size: 40, color: Colors.white)),
                  const Spacer(flex: 1),
                  Text('Register',
                      style:
                          textStyles.titleLarge?.copyWith(color: Colors.white)),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            Container(
              height: size.height * 0.8, 
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: const _RegisterForm(),
            )
          ],
        ),
      ))),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

   void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final registerForm = ref.watch(registerFormProvider);

  ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(
            flex: 3,
          ),
          Text('Create Account', style: textStyles.titleMedium),
          const Spacer(
            flex: 3,
          ),
          SizedBox(
            child: Form(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  // const SizedBox(height: 15),

                  CustomTextFormField(
                    label: 'Full name',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: ref
                        .read(registerFormProvider.notifier)
                        .onFullNameChange,
                    errorMessage: registerForm.isFormPosted
                        ? registerForm.fullName.errorMessage
                        : null,
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onChanged:
                        ref.read(registerFormProvider.notifier).onEmailChange,
                    errorMessage: registerForm.isFormPosted
                        ? registerForm.email.errorMessage
                        : null,
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    label: 'Password',
                    obscureText: true,
                    onChanged: ref
                        .read(registerFormProvider.notifier)
                        .onPasswordChanged,
                    errorMessage: registerForm.isFormPosted
                        ? registerForm.password.errorMessage
                        : null,
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    label: 'Confirm password',
                    obscureText: true,
                    onChanged: ref
                        .read(registerFormProvider.notifier)
                        .onPasswordRepeatChanged,
                    onFieldSubmitted: (_) => ref
                        .read(registerFormProvider.notifier)
                        .onFormSubmitRegister(),
                    errorMessage: registerForm.isFormPosted
                        ? registerForm.repeatPassword.errorMessage
                        : null,
                  ),
                ])),
          ),
          const Spacer(
            flex: 5,
          ),
          SizedBox(
              width: double.infinity,
              height: 40,
              child: CustomFilledButton(
                text: 'Create account',
                buttonColor: Colors.black,
                onPressed: registerForm.isPosting
                    ? null
                    : ref
                        .read(registerFormProvider.notifier)
                        .onFormSubmitRegister,
              )),
          const Spacer(
            flex: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Do you have an account?'),
              TextButton(
                  onPressed: () {
                    if (context.canPop()) {
                      return context.pop();
                    }
                    context.go('/login');
                  },
                  child: const Text('Login'))
            ],
          ),
        ],
      ),
    );
  }
}
