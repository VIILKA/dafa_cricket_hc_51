import 'package:dafa_cricket/services/sign_up_services.dart';
import 'package:flutter/material.dart';

class AvatarSelectionPage extends StatefulWidget {
  final String currentAvatarPath;

  const AvatarSelectionPage({super.key, required this.currentAvatarPath});

  @override
  State<AvatarSelectionPage> createState() => _AvatarSelectionPageState();
}

class _AvatarSelectionPageState extends State<AvatarSelectionPage> {
  String? _selectedAvatarPath;

  // Цветовая схема
  static const Color _primaryBlue = Color(0xFF1E3D59);
  static const Color _secondaryBlue = Color(0xFF17C3B2);
  static const Color _goldLight = Color(0xFFFFD700);
  static const Color _goldDark = Color(0xFFDAA520);
  static const Color _surfaceColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _selectedAvatarPath = widget.currentAvatarPath;
  }

  Future<void> _updateAvatar(BuildContext context, String newAvatarPath) async {
    setState(() {
      _selectedAvatarPath = newAvatarPath;
    });
  }

  Future<void> _saveAvatar() async {
    if (_selectedAvatarPath != null) {
      final profile = await SharedPrefsService.getUserProfile();
      await SharedPrefsService.updateUserProfile(
        firstName: profile['firstName'] ?? '',
        lastName: profile['lastName'] ?? '',
        age: profile['age'] ?? '',
        weight: profile['weight'] ?? '',
        avatarPath: _selectedAvatarPath!,
      );
      if (mounted) {
        Navigator.pop(context, _selectedAvatarPath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarPaths = [
      'assets/images/avatar.png',
      'assets/images/avatar2.png',
      'assets/images/avatar3.png',
      'assets/images/avatar4.png',
      'assets/images/avatar5.png',
      'assets/images/avatar6.png',
      'assets/images/avatar7.png',
      'assets/images/avatar8.png',
      'assets/images/avatar9.png',
    ];

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
          child: Column(
            children: [
              // Шапка
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
                      'Change Avatar',
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

              // Текущий аватар
              Container(
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
                    backgroundImage: AssetImage(
                      _selectedAvatarPath ?? 'assets/images/avatar.png',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Сетка аватаров
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
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
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.0,
                        ),
                    itemCount: avatarPaths.length,
                    itemBuilder: (context, index) {
                      final avatarPath = avatarPaths[index];
                      return GestureDetector(
                        onTap: () => _updateAvatar(context, avatarPath),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient:
                                _selectedAvatarPath == avatarPath
                                    ? LinearGradient(
                                      colors: [_goldLight, _goldDark],
                                    )
                                    : null,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(avatarPath),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Кнопка сохранения
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveAvatar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save Avatar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
