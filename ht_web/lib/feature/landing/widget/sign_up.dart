import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/auth/auth_bloc.dart';
import 'package:ht_web/auth/event/auth_event.dart';
import 'package:ht_web/feature/landing/widget/field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confPass = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(50),
        decoration: style(context),
        height: MediaQuery.sizeOf(context).height * .7,
        child: _body,
      ),
    );
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _pass.dispose();
    _confPass.dispose();
    super.dispose();
  }

  Widget get _body => Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Field(
              controller: _fullName,
              label: "Full Name",
              validator: (p0) {
                if (p0 == null || p0.isEmpty) return 'Required';
                return null;
              },
            ),
            Field(controller: _email, label: "Email"),
            Field(controller: _pass, label: "Passwrd", isPassword: true),
            Field(
              controller: _confPass,
              label: "Confairm Passwrd",
              isPassword: true,
              validator: (p0) {
                if (p0 == null || p0.isEmpty) return 'Required';
                if (p0 != _pass.text) {
                  return 'Password and Confirm Password must match';
                }
                return null;
              },
            ),
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
                        AuthRegister(
                          fname: _fullName.text,
                          email: _email.text,
                          pass: _pass.text,
                        ),
                      );
                }
              },
              child: const Text("Sign Up"),
            ),
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
