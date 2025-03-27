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
      backgroundColor: const Color(0xFFFDF7E0),
      body: SafeArea(
        child: Column(
          children: [
            // Шапка с заголовком и кнопкой назад
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Кнопка "назад"
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF16151A),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Заголовок
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF16151A),
                    ),
                  ),
                  // Пустое пространство для симметрии
                  const SizedBox(width: 24),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Аватар пользователя
            GestureDetector(
              onTap: _openAvatarSelection,
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF292D33),
                      image: DecorationImage(
                        image: AssetImage(_avatarPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9A0104),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFDF7E0),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Форма редактирования данных
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16151A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFDF7E0),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Имя
                        _buildInputField(
                          label: 'First Name',
                          controller: _firstNameController,
                        ),
                        const SizedBox(height: 15),

                        // Фамилия
                        _buildInputField(
                          label: 'Last Name',
                          controller: _lastNameController,
                        ),
                        const SizedBox(height: 15),

                        // Email
                        _buildInputField(
                          label: 'Email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 15),

                        // Возраст
                        _buildInputField(
                          label: 'Age',
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 40),

                        // Кнопка сохранения
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9A0104),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Color(0xFFFDF7E0),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Индикатор внизу экрана
            Container(
              height: 5,
              width: 134,
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
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
          style: const TextStyle(fontSize: 14, color: Color(0xFFFDF7E0)),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFDF7E0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Color(0xFF16151A), fontSize: 15),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
