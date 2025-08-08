
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/idea_bloc/idea_bloc.dart';
import '../../logic/idea_bloc/idea_event.dart';
import '../widgets/animated_background.dart';
class SubmissionScreen extends StatefulWidget {
  const SubmissionScreen({super.key});

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final tagCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    tagCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    context.read<IdeaBloc>().add(AddIdeaEvent(
      nameCtrl.text.trim(),
      tagCtrl.text.trim(),
      descCtrl.text.trim(),
    ));

    await Future.delayed(const Duration(milliseconds: 600));

    Fluttertoast.showToast(
        msg: "Idea submitted successfully! 🎉",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Submit an Idea"),
      ),
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Pitch your next big thing',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(
                      controller: nameCtrl,
                      labelText: 'Startup Name',
                      icon: Icons.business_center_outlined,
                      validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Please enter a name' : null,
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.5),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: tagCtrl,
                      labelText: 'Catchy Tagline',
                      icon: Icons.lightbulb_outline,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Please enter a tagline'
                          : null,
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.5),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: descCtrl,
                      labelText: 'Detailed Description',
                      icon: Icons.description_outlined,
                      maxLines: 5,
                      validator: (v) => (v == null || v.trim().length < 20)
                          ? 'Description must be at least 20 characters'
                          : null,
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.5),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        // icon: const Icon(Icons.rocket_launch_outlined),
                        onPressed: _isSubmitting ? null : _submit,
                        label: _isSubmitting
                            ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : const Text(
                          'Submit Idea',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String? Function(String?) validator,
    int? maxLines = 1,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: labelText,
        prefixIcon: Icon(icon, color: theme.colorScheme.secondary),
        filled: true,
        fillColor: theme.cardColor.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}