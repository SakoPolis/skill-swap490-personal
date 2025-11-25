import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  String? _error;

  /// Offer categories the user selects during sign-up
  final Set<String> _selectedOfferCategories = {};

  /// All available high-level categories
  static const List<Map<String, String>> _allOfferCategories = [
    {'id': 'technical', 'label': 'Technical'},
    {'id': 'creative', 'label': 'Creative / Artistic'},
    {'id': 'academic', 'label': 'Academic / Educational'},
    {'id': 'business', 'label': 'Business / Professional'},
    {'id': 'trades', 'label': 'Trades / Hands-On'},
    {'id': 'lifestyle', 'label': 'Lifestyle & Personal Dev'},
    {'id': 'social', 'label': 'Social & Community'},
    {'id': 'digital_content', 'label': 'Digital Content / Social Media'},
    {'id': 'career', 'label': 'Career & Tech Advancement'},
  ];

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final auth = FirebaseAuth.instance;
      UserCredential cred;

      if (_isLogin) {
        cred = await auth.signInWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        );
      } else {
        cred = await auth.createUserWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        );

        // On first sign-up, create a user document in Firestore
        final user = cred.user!;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'email': user.email,
          'displayName': user.email?.split('@').first,
          'offers': [],
          'wants': [],
          'offerCategories': _selectedOfferCategories.toList(),
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

// After successful login or sign-up
if (mounted) {
  if (_isLogin) {
    Navigator.pushReplacementNamed(context, '/browse');
  } else {
    Navigator.pushReplacementNamed(context, '/profile-setup');
  }
}
} on FirebaseAuthException catch (e) {
  String errorText;

  switch (e.code) {
    case 'invalid-email':
    case 'wrong-password':
    case 'user-not-found':
      errorText = 'Incorrect email or password.';
      break;

    case 'user-disabled':
      errorText = 'This account has been disabled.';
      break;

    case 'too-many-requests':
      errorText = 'Too many attempts. Try again later.';
      break;

    default:
      errorText = 'Could not log in. Please try again.';
  }

  setState(() {
    _error = errorText;
  });
} catch (e) {
  setState(() {
    _error = 'Something went wrong. Please try again.';
  });
} finally {
  if (mounted) {
    setState(() => _isLoading = false);
  }
}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _isLogin ? 'Log in' : 'Create account',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isLogin
                              ? "Welcome back to SkillSwap"
                              : "Join SkillSwap",
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Enter your email';
                            }
                            if (!v.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          obscureText: true,
                          validator: (v) {
                            if (v == null || v.length < 6) {
                              return 'Min 6 characters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // ONLY show category selection on sign-up
                        if (!_isLogin) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "What types of skills do you offer?",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Choose all that apply. You can add more later.",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _allOfferCategories.map((cat) {
                              final id = cat['id']!;
                              final label = cat['label']!;
                              final isSelected =
                                  _selectedOfferCategories.contains(id);

                              return FilterChip(
                                label: Text(label),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedOfferCategories.add(id);
                                    } else {
                                      _selectedOfferCategories.remove(id);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                        ],

                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(_isLogin ? 'Log in' : 'Sign up'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                    _error = null;
                                    // Clear categories when switching modes
                                    _selectedOfferCategories.clear();
                                  });
                                },
                          child: Text(
                            _isLogin
                                ? "New here? Create an account"
                                : "Already have an account? Log in",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
