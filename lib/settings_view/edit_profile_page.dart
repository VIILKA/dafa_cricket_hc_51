import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dafa_cricket/services/sign_up_services.dart';
import 'package:dafa_cricket/settings_view/avatar_selection_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dafa_cricket/core/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialSurname;
  final String initialAge;
  final String initialEmail;
  final String initialAvatarPath;

  const EditProfilePage({
    super.key,
    required this.initialName,
    required this.initialSurname,
    required this.initialAge,
    required this.initialEmail,
    required this.initialAvatarPath,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _ageController;
  late TextEditingController _emailController;
  late String _avatarPath;
  late Box<UserProfile> _userBox;

  // Цветовая схема
  static const Color _primaryBlue = Color(0xFF1E3D59);
  static const Color _secondaryBlue = Color(0xFF17C3B2);
  static const Color _goldLight = Color(0xFFFFD700);
  static const Color _goldDark = Color(0xFFDAA520);
  static const Color _surfaceColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.initialName);
    _lastNameController = TextEditingController(text: widget.initialSurname);
    _ageController = TextEditingController(text: widget.initialAge);
    _emailController = TextEditingController(text: widget.initialEmail);
    _avatarPath = widget.initialAvatarPath;
    _userBox = Hive.box('user');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final age = _ageController.text.trim();
    final email = _emailController.text.trim();

    // Обновляем профиль пользователя в Hive
    final updatedProfile = UserProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      avatarPath: _avatarPath,
      level: age,
    );

    await _userBox.put('current_user', updatedProfile);

    // Для обратной совместимости с SharedPreferences
    await SharedPrefsService.updateUserProfile(
      firstName: firstName,
      lastName: lastName,
      age: age,
      weight: '0',
      avatarPath: _avatarPath,
    );

    // Сохраняем email отдельно
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);

    Navigator.pop(context, true);
  }

  Future<void> _openAvatarSelection() async {
    final newAvatarPath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AvatarSelectionPage(currentAvatarPath: _avatarPath),
      ),
    );
    if (newAvatarPath != null) {
      setState(() {
        _avatarPath = newAvatarPath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _primaryBlue,
              _primaryBlue.withOpacity(0.8),
              _secondaryBlue.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Шапка с заголовком и кнопкой назад
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Аватар пользователя
                GestureDetector(
                  onTap: _openAvatarSelection,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [_goldLight, _goldDark]),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 58,
                        backgroundImage: AssetImage(_avatarPath),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Форма редактирования данных
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 4),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Имя
                        _buildInputField(
                          label: 'First Name',
                          controller: _firstNameController,
                        ),
                        const SizedBox(height: 20),

                        // Фамилия
                        _buildInputField(
                          label: 'Last Name',
                          controller: _lastNameController,
                        ),
                        const SizedBox(height: 20),

                        // Email
                        _buildInputField(
                          label: 'Email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // Возраст
                        _buildInputField(
                          label: 'Age',
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 32),

                        // Кнопка сохранения
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Color(0xFF2D3142), fontSize: 16),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
