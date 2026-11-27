import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'catalog_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().login(_email.text, _password.text);
  }

  void _clearError(String _) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(wide ? 48 : 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: wide ? 1080 : 460),
                child: Row(
                  children: [
                    if (wide) ...[
                      const Expanded(child: _WelcomePanel()),
                      const SizedBox(width: 64),
                    ],
                    Expanded(
                      child: BlocConsumer<AuthCubit, AuthState>(
                        // Navigation and notifications belong to the listener only.
                        listener: (context, state) {
                          if (state is AuthError) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: const Color(0xFFDC2626),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                          } else if (state is AuthSuccess) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => const CatalogScreen(),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          final loading = state is AuthLoading;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4F46E5),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.bolt_rounded,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'TechStore',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 36),
                              Container(
                                padding: EdgeInsets.all(wide ? 32 : 24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: const Color(0xFFE7EAF2),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x071E2340),
                                      blurRadius: 40,
                                      offset: Offset(0, 16),
                                    ),
                                  ],
                                ),
                                child: AutofillGroup(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        'Welcome back',
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -1,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Sign in to continue shopping.',
                                        style: TextStyle(
                                          color: Color(0xFF64748B),
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      const _FieldLabel('Email address'),
                                      TextField(
                                        controller: _email,
                                        onChanged: _clearError,
                                        readOnly: loading,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        autofillHints: const [
                                          AutofillHints.email,
                                        ],
                                        autocorrect: false,
                                        decoration: const InputDecoration(
                                          hintText: 'you@example.com',
                                          prefixIcon: Icon(
                                            Icons.mail_outline_rounded,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const _FieldLabel('Password'),
                                      TextField(
                                        controller: _password,
                                        onChanged: _clearError,
                                        readOnly: loading,
                                        obscureText: _obscure,
                                        autofillHints: const [
                                          AutofillHints.password,
                                        ],
                                        autocorrect: false,
                                        enableSuggestions: false,
                                        onSubmitted: (_) => _login(),
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                          hintText: 'Enter your password',
                                          prefixIcon: const Icon(
                                            Icons.lock_outline_rounded,
                                            size: 20,
                                          ),
                                          suffixIcon: IconButton(
                                            tooltip: _obscure
                                                ? 'Show password'
                                                : 'Hide password',
                                            // Visibility is local UI state; authentication is owned by Cubit.
                                            onPressed: () => setState(
                                              () => _obscure = !_obscure,
                                            ),
                                            icon: Icon(
                                              _obscure
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                        .visibility_off_outlined,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 28),
                                      SizedBox(
                                        height: 54,
                                        child: AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          child: loading
                                              ? const Center(
                                                  child: SizedBox.square(
                                                    dimension: 26,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 3,
                                                        ),
                                                  ),
                                                )
                                              : SizedBox.expand(
                                                  child: FilledButton(
                                                    onPressed: _login,
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('Sign in'),
                                                        SizedBox(width: 12),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_rounded,
                                                          size: 18,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
  );
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(40),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(32),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF20203E), Color(0xFF393278)],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CURATED FOR YOUR EVERYDAY',
          style: TextStyle(
            color: Color(0xFFBEB9F9),
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 52),
        Center(
          child: Container(
            padding: const EdgeInsets.all(36),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4B438B),
              border: Border.all(color: const Color(0xFF6860A6)),
            ),
            child: const Icon(
              Icons.headphones_rounded,
              size: 100,
              color: Color(0xFFE8E5FF),
            ),
          ),
        ),
        const SizedBox(height: 48),
        const Text(
          'Good tech.\nGreat everyday.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 42,
            height: 1.1,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Discover the little upgrades that make a big difference.',
          style: TextStyle(color: Color(0xFFCBC8E4), fontSize: 16, height: 1.6),
        ),
      ],
    ),
  );
}
