import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labourlink/login.dart';

// ---------------- API CONFIG ----------------
final Dio dio = Dio();
final String baseurl = "http://192.168.1.87:8000";

// ---------------- REGISTER PAGE ----------------
class RegisterFormPage1 extends StatefulWidget {
  const RegisterFormPage1({super.key});

  @override
  State<RegisterFormPage1> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage1>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _uniqueIdController = TextEditingController();
  final _wageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otherSkillController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  bool _isSubmitting = false;
  File? _selectedImage;
  DateTime? _selectedDOB;

  // Location
  double? _latitude;
  double? _longitude;

  // Skills
  final List<String> _skills = [
    'Construction',
    'Electrician',
    'Plumber',
    'Carpenter',
    'Painter',
    'Welder',
    'Driver',
    'Mechanic',
    'Gardener',
    'Helper',
    'Mason',
    'Cook',
    'Housekeeping',
    'Security Guard',
    'Other',
  ];
  final List<String> _selectedSkills = [];
  bool _showSkillError = false;

  // Animation
  late final AnimationController _controller;

  final Color _primaryColor = const Color(0xFF4A00E0);
  final Color _secondaryColor = const Color(0xFF8E2DE2);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _determinePosition();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _uniqueIdController.dispose();
    _wageController.dispose();
    _passwordController.dispose();
    _otherSkillController.dispose();
    super.dispose();
  }

  // ---------------- LOCATION ----------------
  Future<void> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _latitude = pos.latitude;
      _longitude = pos.longitude;
    });
  }

  // ---------------- DOB PICKER ----------------
  Future<void> _pickDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _selectedDOB = picked;
      _dobController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      _calculateAge(picked);
    }
  }

  void _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    _ageController.text = age.toString();
  }

  // ---------------- IMAGE PICK ----------------
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  // ---------------- SUBMIT ----------------
  Future<void> _submit() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    setState(() => _showSkillError = false);

    if (!_formKey.currentState!.validate()) return;

    if (_selectedSkills.isEmpty) {
      setState(() => _showSkillError = true);
      return;
    }

    if (_selectedImage == null) {
      _showError("Please select a profile photo");
      return;
    }

    if (_selectedDOB == null) {
      _showError("Please select Date of Birth");
      return;
    }

    if (_latitude == null || _longitude == null) {
      await _determinePosition();
    }

    if (_latitude == null || _longitude == null) {
      _showError("Unable to get location");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final skillsString = _selectedSkills
          .map((s) => s == 'Other' ? _otherSkillController.text.trim() : s)
          .where((s) => s.isNotEmpty)
          .join(', ');

      final formData = FormData.fromMap({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'uniqueid': _uniqueIdController.text,
        'wage': _wageController.text,
        'password': _passwordController.text,
        'skills': skillsString,

        // ✅ DOB & AGE
        'dob': _dobController.text,
        'age': _ageController.text,

        // ✅ LOCATION
        'location': {'lat': _latitude, 'lng': _longitude},

        'photo': await MultipartFile.fromFile(
          _selectedImage!.path,
          filename: _selectedImage!.path.split('/').last,
        ),
      });

      final response = await dio.post(
        '$baseurl/api/worker/register',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        throw Exception("Registration failed");
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [_secondaryColor, _primaryColor]),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildGlassCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(24),
          color: Colors.white.withOpacity(0.9),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? const Icon(Icons.add_a_photo, size: 32)
                        : null,
                  ),
                ),

                const SizedBox(height: 20),

                _field(_nameController, "Name"),
                _field(_emailController, "Email"),
                _field(_phoneController, "Phone"),

                _field(
                  _dobController,
                  "Date of Birth",
                  readOnly: true,
                  onTap: _pickDOB,
                ),
                _field(_ageController, "Age", readOnly: true),

                _field(_uniqueIdController, "Unique ID"),
                _field(_wageController, "Wage"),
                _field(_passwordController, "Password", obscure: true),

                const SizedBox(height: 16),

                _buildSkillSelector(),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Register"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Skills",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _skills.map((skill) {
            final selected = _selectedSkills.contains(skill);
            return FilterChip(
              label: Text(skill),
              selected: selected,
              selectedColor: _primaryColor,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.black,
              ),
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedSkills.add(skill);
                    _showSkillError = false;
                  } else {
                    _selectedSkills.remove(skill);
                    if (skill == 'Other') _otherSkillController.clear();
                  }
                });
              },
            );
          }).toList(),
        ),
        if (_showSkillError)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              "Please select at least one skill",
              style: TextStyle(color: Colors.red),
            ),
          ),
        if (_selectedSkills.contains('Other'))
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _field(_otherSkillController, "Specify other skill"),
          ),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        readOnly: readOnly,
        onTap: onTap,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
