import 'dart:io'; // Required for File handling
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// NOTE: To enable real camera/gallery functionality:
// 1. Run in terminal: flutter pub add image_picker
// 2. Uncomment the import below:
// import 'package:image_picker/image_picker.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterFormPage1(),
    ),
  );
}

// Placeholder for FeedbackPage (Screen after successful submission)
class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration Successful")),
      body: const Center(child: Text("Welcome to LabourLink!")),
    );
  }
}

class RegisterFormPage1 extends StatefulWidget {
  const RegisterFormPage1({super.key});

  @override
  State<RegisterFormPage1> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage1>
    with SingleTickerProviderStateMixin {
  // --- Controllers ---
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _wageController = TextEditingController(); // <--- NEW CONTROLLER
  final _otherSkillController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // --- State Variables ---
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  DateTime? _selectedDate;

  // Image Variable
  File? _selectedImage;

  // --- Country Code Logic ---
  String _selectedCountryCode = '+91';

  final List<Map<String, String>> _countryData = [
    {'code': '+91', 'flag': '🇮🇳'},
    {'code': '+1', 'flag': '🇺🇸'},
    {'code': '+44', 'flag': '🇬🇧'},
    {'code': '+971', 'flag': '🇦🇪'},
    {'code': '+966', 'flag': '🇸🇦'},
    {'code': '+81', 'flag': '🇯🇵'},
    {'code': '+86', 'flag': '🇨🇳'},
    {'code': '+61', 'flag': '🇦🇺'},
    {'code': '+49', 'flag': '🇩🇪'},
    {'code': '+33', 'flag': '🇫🇷'},
    {'code': '+7', 'flag': '🇷🇺'},
  ];

  // --- Skills Logic ---
  final List<String> _selectedSkills = [];
  bool _showSkillError = false;

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

  // --- Wage Logic ---
  String _selectedWageUnit = 'Per Day';
  final List<String> _wageUnits = ['Per Hour', 'Per Day', 'Per Month'];

  // --- Animation ---
  late final AnimationController _controller;

  // --- Theme Colors ---
  final Color _primaryColor = const Color(0xFF4A00E0);
  final Color _secondaryColor = const Color(0xFF8E2DE2);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _wageController.dispose(); // <--- Dispose Wage Controller
    _otherSkillController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // --- Photo Picker Logic ---
  Future<void> _pickImage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Add 'image_picker' package to enable Camera/Gallery"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // --- Date Picker Logic ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
        _calculateAge(picked);
      });
    }
  }

  void _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    _ageController.text = age.toString();
  }

  // --- Submit Logic ---
  Future<void> _submit() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    setState(() {
      _showSkillError = false;
    });

    bool formValid = _formKey.currentState!.validate();
    bool skillValid = _selectedSkills.isNotEmpty;

    if (!skillValid) {
      setState(() {
        _showSkillError = true;
      });
    }

    if (!formValid || !skillValid) {
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 2));

    print("Wage: ${_wageController.text} $_selectedWageUnit");

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const FeedbackPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  // --- Validators ---
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your name';
    if (value.trim().length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  String? _validateDOB(String? value) {
    if (value == null || value.isEmpty) return 'Select Date';
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    int? age = int.tryParse(value);
    if (age == null) return 'Invalid';
    if (age < 18) return 'Under 18';
    if (age > 100) return 'Invalid';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your email';
    const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (!RegExp(emailPattern).hasMatch(value.trim())) {
      return 'Invalid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter phone number';
    if (value.trim().length < 7) return 'Invalid number';
    return null;
  }

  String? _validateWage(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (double.tryParse(value) == null) return 'Invalid amount';
    return null;
  }

  String? _validateOtherSkill(String? value) {
    if (_selectedSkills.contains('Other')) {
      if (value == null || value.trim().isEmpty) return 'Please specify skill';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Min 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Animated Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_secondaryColor, _primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: -50,
            right: -50,
            child: _buildBackgroundShape(200, Colors.white.withOpacity(0.1)),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: _buildBackgroundShape(300, Colors.white.withOpacity(0.05)),
          ),

          // 2. Main Form Content
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: SafeArea(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: _buildGlassCard(),
                ),
              ),
            ),
          ),
        ],
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
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header (Index 0)
                _buildAnimatedItem(
                  index: 0,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_add_rounded,
                          size: 40,
                          color: _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Join LabourLink today',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Photo (Index 1)
                _buildAnimatedItem(index: 1, child: _buildPhotoBox()),

                const SizedBox(height: 24),

                // Name (Index 2)
                _buildAnimatedItem(
                  index: 2,
                  child: _buildModernTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.badge_outlined,
                    validator: _validateName,
                  ),
                ),

                // DOB & Age (Index 3)
                _buildAnimatedItem(
                  index: 3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildModernTextField(
                          controller: _dobController,
                          label: 'Date of Birth',
                          icon: Icons.calendar_month_outlined,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          validator: _validateDOB,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: _buildModernTextField(
                          controller: _ageController,
                          label: 'Age',
                          icon: Icons.onetwothree,
                          readOnly: true,
                          validator: _validateAge,
                        ),
                      ),
                    ],
                  ),
                ),

                // Email (Index 4)
                _buildAnimatedItem(
                  index: 4,
                  child: _buildModernTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    inputType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                ),

                // Phone (Index 5)
                _buildAnimatedItem(
                  index: 5,
                  child: _buildModernTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_android_outlined,
                    inputType: TextInputType.phone,
                    validator: _validatePhone,
                    prefixWidget: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 8),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCountryCode,
                              dropdownColor: Colors.white,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              items: _countryData.map((
                                Map<String, String> item,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: item['code'],
                                  child: Row(
                                    children: [
                                      Text(
                                        item['flag']!,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        item['code']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCountryCode = value!;
                                });
                              },
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            indent: 10,
                            endIndent: 10,
                            thickness: 1,
                          ),
                          const SizedBox(width: 0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Skills (Index 6)
                _buildAnimatedItem(index: 6, child: _buildSkillSelector()),

                // --- NEW WAGE SECTION (Index 7) ---
                _buildAnimatedItem(
                  index: 7,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Amount Input
                      Expanded(
                        flex: 2,
                        child: _buildModernTextField(
                          controller: _wageController,
                          label: 'Expected Wage',
                          icon: Icons.currency_rupee, // Or Icons.attach_money
                          inputType: TextInputType.number,
                          validator: _validateWage,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Frequency Dropdown
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 60, // Matches TextField height
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedWageUnit,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              items: _wageUnits.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedWageUnit = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Password (Index 8)
                _buildAnimatedItem(
                  index: 8,
                  child: _buildModernTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    onVisibilityToggle: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    validator: _validatePassword,
                  ),
                ),

                // Confirm Password (Index 9)
                _buildAnimatedItem(
                  index: 9,
                  child: _buildModernTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    icon: Icons.lock_reset,
                    isPassword: true,
                    isLast: true,
                    obscureText: _obscureConfirmPassword,
                    onVisibilityToggle: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
                    validator: _validateConfirmPassword,
                  ),
                ),

                const SizedBox(height: 30),

                // Submit Button (Index 10)
                _buildAnimatedItem(
                  index: 10,
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: _primaryColor.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Login Link (Index 11)
                _buildAnimatedItem(
                  index: 11,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Already have an account? Login',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildPhotoBox() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                border: Border.all(color: _primaryColor, width: 2),
                image: _selectedImage != null
                    ? DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: _selectedImage == null
                  ? Icon(
                      Icons.add_a_photo_rounded,
                      size: 40,
                      color: _primaryColor.withOpacity(0.5),
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Row(
              children: [
                Icon(Icons.work_outline, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  "Select Skill/Job (Multiple allowed)",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: _showSkillError
                  ? Border.all(color: Colors.redAccent, width: 1)
                  : null,
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills.map((skill) {
                final isSelected = _selectedSkills.contains(skill);
                return FilterChip(
                  label: Text(skill),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  selected: isSelected,
                  checkmarkColor: Colors.white,
                  selectedColor: _primaryColor,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSkills.add(skill);
                        _showSkillError = false;
                      } else {
                        _selectedSkills.remove(skill);
                        if (skill == 'Other') {
                          _otherSkillController.clear();
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          if (_showSkillError)
            Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 12.0),
              child: Text(
                'Please select at least one skill',
                style: TextStyle(color: Colors.red[700], fontSize: 12),
              ),
            ),
          if (_selectedSkills.contains('Other'))
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: _buildModernTextField(
                controller: _otherSkillController,
                label: 'Specify your Skill/Job',
                icon: Icons.edit_note,
                validator: _validateOtherSkill,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    bool isLast = false,
    bool readOnly = false,
    Widget? prefixWidget,
    VoidCallback? onTap,
    VoidCallback? onVisibilityToggle,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        keyboardType: inputType,
        textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
        style: const TextStyle(fontWeight: FontWeight.w500),
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: prefixWidget ?? Icon(icon, color: Colors.grey[500]),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[500],
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: _primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildAnimatedItem({required int index, required Widget child}) {
    final double startTime = index * 0.05;
    final double endTime = startTime + 0.4;

    final slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(startTime, endTime, curve: Curves.easeOutCubic),
          ),
        );

    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(startTime, endTime, curve: Curves.easeOut),
      ),
    );

    return FadeTransition(
      opacity: fadeAnim,
      child: SlideTransition(position: slideAnim, child: child),
    );
  }

  Widget _buildBackgroundShape(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
