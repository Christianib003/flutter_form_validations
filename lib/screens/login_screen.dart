import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  bool _agreedToTerms = false;
  bool _showTermsError = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateValidation);
    _passwordController.addListener(_updateValidation);
    _confirmPasswordController.addListener(_updateValidation);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateValidation);
    _passwordController.removeListener(_updateValidation);
    _confirmPasswordController.removeListener(_updateValidation);
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateValidation() {
    if (mounted) {
      setState(() {
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        _isEmailValid = _emailController.text.isNotEmpty &&
            emailRegex.hasMatch(_emailController.text);

        _isPasswordValid = _passwordController.text.length >= 6 &&
            _passwordController.text.contains(RegExp(r'[A-Z]')) &&
            _passwordController.text
                .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

        _isConfirmPasswordValid = _confirmPasswordController.text.isNotEmpty &&
            _confirmPasswordController.text == _passwordController.text;
      });
    }
  }

  void _validateForm() {
    setState(() {
      _showTermsError = !_agreedToTerms;
    });

    if (_isEmailValid &&
        _isPasswordValid &&
        _isConfirmPasswordValid &&
        _agreedToTerms) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                isPassword: false,
                validationRules: const ['Must be a valid email address'],
                validator: (value) => _isEmailValid ? null : 'Invalid email',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
                validationRules: const [
                  'At least 6 characters',
                  'At least one capital letter',
                  'At least one punctuation mark'
                ],
                validator: (value) =>
                    _isPasswordValid ? null : 'Invalid password',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                isPassword: true,
                validationRules: const ['Must match password'],
                validator: (value) =>
                    _isConfirmPasswordValid ? null : 'Passwords do not match',
                passwordController: _passwordController,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreedToTerms = value ?? false;
                        if (_agreedToTerms) {
                          _showTermsError = false;
                        }
                      });
                    },
                    side: BorderSide(
                      color: _showTermsError ? Colors.red : Colors.grey,
                      width: _showTermsError ? 2 : 1,
                    ),
                  ),
                  const Text('I agree to the terms and conditions'),
                ],
              ),
              if (_showTermsError)
                const Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 4.0),
                  child: Text(
                    'You must agree to the terms and conditions',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _validateForm,
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
