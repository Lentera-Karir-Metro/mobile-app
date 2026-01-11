import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/inputs/primary_text_field.dart';

/// Halaman Settings
/// Menampilkan pengaturan akun pengguna
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // Controllers untuk text fields
  final TextEditingController _usernameController = TextEditingController(text: 'Ridho Dwi Syahputra');
  final TextEditingController _emailController = TextEditingController(text: 'ridhooo@gmail.com');
  final TextEditingController _descriptionController = TextEditingController(text: 'Online Learning Enthusiast');
  final TextEditingController _passwordController = TextEditingController(text: 'password123');
  
  // State untuk email notifications toggle
  bool _emailNotificationsEnabled = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan back button dan title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Row(
                children: [
                  // Back button
                  CustomBackButton(
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  // Title
                  Text(
                    'Settings',
                    style: AppTextStyles.heading3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Card container untuk form
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Profile photo dengan ubah foto button
                          Column(
                            children: [
                              // Circular photo placeholder
                              Container(
                                width: 77,
                                height: 77,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.divider,
                                  image: const DecorationImage(
                                    image: AssetImage('assets/hardcode/profile-photo.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Ubah Foto text
                              Text(
                                'Ubah Foto',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Username field
                          PrimaryTextField(
                            labelText: 'Username',
                            controller: _usernameController,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16),

                          // Email Address field
                          PrimaryTextField(
                            labelText: 'Email Address',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),

                          // Description field
                          PrimaryTextField(
                            labelText: 'Description',
                            controller: _descriptionController,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16),

                          // Password field dengan toggle visibility
                          PrimaryTextField(
                            labelText: 'Password',
                            controller: _passwordController,
                            obscureText: true,
                            showPasswordToggle: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email Notifications card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email Notifications',
                                  style: AppTextStyles.body1.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Allow it to send an email\nof incoming notifications',
                                  style: AppTextStyles.body2.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Toggle switch
                          Switch(
                            value: _emailNotificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _emailNotificationsEnabled = value;
                              });
                            },
                            thumbColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.primaryPurple;
                                }
                                return Colors.grey;
                              },
                            ),
                            trackColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.primaryPurple.withValues(alpha: 0.5);
                                }
                                return Colors.grey.withValues(alpha: 0.5);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
