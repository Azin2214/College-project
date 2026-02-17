import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class WorkDetailsUser extends StatefulWidget {
  const WorkDetailsUser({super.key});

  @override
  State<WorkDetailsUser> createState() => _WorkDetailsUserState();
}

class _WorkDetailsUserState extends State<WorkDetailsUser>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // State
  bool _isSubmitting = false;

  // Animation
  late final AnimationController _controller;

  // Theme Colors
  final Color _primaryColor = const Color(0xFF4A00E0);
  final Color _secondaryColor = const Color(0xFF8E2DE2);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // --- Logic ---

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    HapticFeedback.selectionClick();
    final DateTime now = DateTime.now();

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateFormat('dd/MM/yyyy').parse(value);
    } catch (_) {
      return null;
    }
  }

  Future<void> _submit() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate API
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green,
                child: Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              const Text(
                "Work Added!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Your work history has been updated successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    _formKey.currentState?.reset();
                    _startDateController.clear();
                    _endDateController.clear();
                    _titleController.clear();
                    _descriptionController.clear();
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Career History",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 1. Animated Background
          const AnimatedGradientBackground(),

          // 2. Floating Shapes
          Positioned(
            top: -60,
            left: -40,
            child: _buildBackgroundShape(200, Colors.white.withOpacity(0.1)),
          ),
          Positioned(
            bottom: 100,
            right: -50,
            child: _buildBackgroundShape(150, Colors.white.withOpacity(0.05)),
          ),

          // 3. Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 100,
                bottom: 40,
                left: 20,
                right: 20,
              ),
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: _buildGlassCard(),
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
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _buildAnimatedItem(
                  index: 0,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.work_outline,
                          size: 40,
                          color: _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Add Work Details",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Keep your profile updated for better opportunities",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Job Title
                _buildAnimatedItem(
                  index: 1,
                  child: _buildModernTextField(
                    controller: _titleController,
                    label: "Job Title",
                    hint: "e.g. Senior Carpenter",
                    icon: Icons.badge_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Job Title";
                      }
                      if (value.trim().length < 3) return "Min 3 characters";
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Dates Row (Responsive)
                _buildAnimatedItem(
                  index: 2,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 400;
                      return Flex(
                        direction: isWide ? Axis.horizontal : Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: isWide ? 1 : 0,
                            child: _buildDatePickerField(
                              controller: _startDateController,
                              label: "Start Date",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (_parseDate(value) == null) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: isWide ? 16 : 0,
                            height: isWide ? 0 : 20,
                          ),
                          Expanded(
                            flex: isWide ? 1 : 0,
                            child: _buildDatePickerField(
                              controller: _endDateController,
                              label: "End Date",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                final start = _parseDate(
                                  _startDateController.text,
                                );
                                final end = _parseDate(value);
                                if (start != null &&
                                    end != null &&
                                    end.isBefore(start)) {
                                  return 'Must be after Start Date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                _buildAnimatedItem(
                  index: 3,
                  child: _buildModernTextField(
                    controller: _descriptionController,
                    label: "Description",
                    hint: "Describe your roles and responsibilities...",
                    icon: Icons.description_outlined,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Required";
                      if (value.trim().length < 10) return "Min 10 characters";
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                _buildAnimatedItem(
                  index: 4,
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
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
                              "Add Work",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
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

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: maxLines > 1
            ? Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Icon(icon, color: Colors.grey[500]),
              )
            : Icon(icon, color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
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
      ),
      validator: validator,
    );
  }

  Widget _buildDatePickerField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context, controller),
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
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
      ),
      validator: validator,
    );
  }

  Widget _buildAnimatedItem({required int index, required Widget child}) {
    final double startTime = index * 0.1;
    final double endTime = startTime + 0.4;
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(startTime, endTime, curve: Curves.easeOut),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(startTime, endTime, curve: Curves.easeOutCubic),
              ),
            ),
        child: child,
      ),
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

// --- ANIMATED BACKGROUND (Reusable) ---
class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> {
  Alignment _topAlignment = Alignment.topLeft;
  Alignment _bottomAlignment = Alignment.bottomRight;
  final Color _color1 = const Color(0xFF4A00E0);
  final Color _color2 = const Color(0xFF8E2DE2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());
  }

  void _startAnimation() {
    if (!mounted) return;
    setState(() {
      _topAlignment = _topAlignment == Alignment.topLeft
          ? Alignment.bottomLeft
          : Alignment.topLeft;
      _bottomAlignment = _bottomAlignment == Alignment.bottomRight
          ? Alignment.topRight
          : Alignment.bottomRight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 4),
      curve: Curves.easeInOut,
      onEnd: _startAnimation,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_color1, _color2],
          begin: _topAlignment,
          end: _bottomAlignment,
          stops: const [0.2, 0.8],
        ),
      ),
    );
  }
}
