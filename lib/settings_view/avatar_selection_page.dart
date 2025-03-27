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
    // Список путей к аватарам
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
      backgroundColor: const Color(0xFFFDF7E0),
      body: SafeArea(
        child: Column(
          children: [
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
                    'Change avatar',
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

            // Текущий аватар
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                height: 176,
                width: 176,
                child:
                    _selectedAvatarPath != null
                        ? CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(_selectedAvatarPath!),
                        )
                        : const CircleAvatar(
                          backgroundColor: Color(0xFF292D32),
                          child: Icon(
                            Icons.person_outline,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),

            // Сетка аватаров
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: avatarPaths.length,
                  itemBuilder: (context, index) {
                    final avatarPath = avatarPaths[index];
                    return GestureDetector(
                      onTap: () {
                        _updateAvatar(context, avatarPath);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              _selectedAvatarPath == avatarPath
                                  ? Border.all(
                                    color: const Color(0xFF9A0104),
                                    width: 2,
                                  )
                                  : null,
                        ),
                        child: ClipOval(
                          child: Image.asset(avatarPath, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Кнопка "Сохранить"
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveAvatar,
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
            ),

            // Индикатор внизу экрана
            Container(
              height: 5,
              width: 134,
              margin: const EdgeInsets.only(bottom: 20),
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
}
