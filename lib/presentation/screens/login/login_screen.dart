import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../presentation/provider/auth/auth_provider.dart';
import '../../../presentation/provider/providers.dart';
import '../../../presentation/widgets/shared/shared.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                  height: size.height * 0.3,
                  child: const Icon(
                    Icons.production_quantity_limits_rounded,
                    color: Colors.white,
                    size: 100,
                  )),
              Container(
                height: size.height * 0.7, // 80 los dos sizebox y 100 el ícono
                width: double.infinity,
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(100)),
                ),
                child: const _LoginForm(),
              )
            ],
          ),
        ),
      )),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final loginForm = ref.watch(loginFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;
  
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const Spacer(flex: 4),
          Text('Login',
              style: textStyles.titleLarge, textAlign: TextAlign.center),
          const Spacer(flex: 4),
          Form(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                CustomTextFormField(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: ref.read(loginFormProvider.notifier).onEmailChange,
                  errorMessage: loginForm.isFormPosted
                      ? loginForm.email.errorMessage
                      : null,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  label: 'Password',
                  obscureText: true,
                  onChanged:
                      ref.read(loginFormProvider.notifier).onPasswordChanged,
                  onFieldSubmitted: (_) =>
                      ref.read(loginFormProvider.notifier).onFormSubmitLogin(),
                  errorMessage: loginForm.isFormPosted
                      ? loginForm.password.errorMessage
                      : null,
                ),
                const SizedBox(height: 40),
              ])),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: CustomFilledButton(
                text: 'Login',
                buttonColor: Colors.black,
                onPressed: loginForm.isPosting
                    ? null
                    : ref.read(loginFormProvider.notifier).onFormSubmitLogin),
          ),
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Don’t have an account?'),
              TextButton(
                  onPressed: () => context.push('/register'),
                  child: const Text('Create one'))
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
