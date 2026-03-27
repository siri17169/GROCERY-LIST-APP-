import 'package:flutter/material.dart';
import 'main_nav.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.person_add_rounded, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
              const Text("Join our community!", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              _field(Icons.person_outline, "Full Name"),
              const SizedBox(height: 20),
              _field(Icons.email_outlined, "Email Address", isEmail: true),
              const SizedBox(height: 20),
              _field(Icons.lock_outline, "Password", obscure: true, isPassword: true),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNav()));
                    }
                  },
                  child: const Text("SIGN UP", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(IconData icon, String hint, {bool obscure = false, bool isEmail = false, bool isPassword = false}) {
    return TextFormField(
      obscureText: obscure,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $hint';
        if (isEmail && !value.contains('@')) return 'Enter a valid email';
        if (isPassword && value.length < 6) return 'Password must be 6+ chars';
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }
}
