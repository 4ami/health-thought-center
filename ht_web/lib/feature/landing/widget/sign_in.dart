import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/auth/auth_bloc.dart';
import 'package:ht_web/auth/event/auth_event.dart';
import 'package:ht_web/feature/landing/widget/field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(50),
        decoration: style(context),
        height: MediaQuery.sizeOf(context).height / 2,
        child: _body,
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Widget get _body => Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Field(controller: _email, label: "Email"),
            Field(controller: _pass, label: "Passwrd", isPassword: true),
            if (context.watch<AuthBLOC>().state.event is AuthException)
              Text(
                context.watch<AuthBLOC>().state.event.message ?? '',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    context.read<AuthBLOC>().add(
                          AuthLogin(
                            email: _email.text,
                            pass: _pass.text,
                          ),
                        );
                  }
                },
                child: const Text("Sign In")),
          ],
        ),
      );

  BoxDecoration style(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Theme.of(context).colorScheme.background,
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.onPrimary,
          blurRadius: 32,
          offset: -const Offset(3, 3),
        ),
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withOpacity(.4),
          blurRadius: 32,
          offset: const Offset(18, 18),
        ),
      ],
    );
  }
}
