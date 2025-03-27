import 'dart:ui';

import 'package:dafa_cricket/core/models/user_model.dart';
import 'package:dafa_cricket/services/sign_up_services.dart';
import 'package:dafa_cricket/settings_view/edit_profile_page.dart';
import 'package:dafa_cricket/settings_view/privacy_policy_page.dart';
import 'package:dafa_cricket/settings_view/avatar_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dafa_cricket/core/models/user_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Box<UserProfile> _userBox;
  UserProfile? _currentUser;
  bool _isLoading = true;
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _age = 'N/A';
  String _avatarPath = 'assets/images/avatar.png';
  final String _appVersion = '1.0';

  @override
  void initState() {
    super.initState();
    _userBox = Hive.box('user');
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _userBox.get('current_user');
    setState(() {
      _currentUser = user;
      _firstName = user?.firstName ?? 'No first name';
      _lastName = user?.lastName ?? 'No surname';
      _email = user?.email ?? 'noemail@example.com';
      _age = user?.level ?? 'N/A';
      _avatarPath = user?.avatarPath ?? 'assets/images/avatar.png';
      _isLoading = false;
    });
  }

  Future<void> _updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? avatarPath,
  }) async {
    final updatedProfile = UserProfile(
      firstName: firstName ?? _currentUser?.firstName ?? '',
      lastName: lastName ?? _currentUser?.lastName ?? '',
      email: email ?? _currentUser?.email ?? '',
      avatarPath: avatarPath ?? _currentUser?.avatarPath ?? '',
      level: _currentUser?.level ?? 'beginner',
    );

    await _userBox.put('current_user', updatedProfile);
    await _loadProfile();
  }

  Future<void> _openEditProfile() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => EditProfilePage(
              initialName: _firstName,
              initialSurname: _lastName,
              initialAge: _age,
              initialEmail: _email,
              initialAvatarPath: _avatarPath,
            ),
      ),
    );
    if (updated == true) {
      _loadProfile();
    }
  }

  void _openPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
    );
  }

  void _openAboutUs() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              "About cal",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            content: Text(
              '''cal is your educational companion, designed to enhance your learning journey.

🚀 Our Mission
- Provide engaging courses and quizzes.
- Offer insightful progress analytics.
- Build a supportive community of learners.

🎯 Our Values
- Quality and reliability.
- Seamless user experience.
- Privacy and security.

Stay curious. Keep learning. Achieve your goals with cal!''',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _openContactUs() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              "Contact Us",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            content: Text(
              "Have questions or suggestions? Reach out at support@cal.com",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _handleShare() {
    Share.share('Discover cal – your ultimate educational companion!');
  }

  void _handleRate() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              "Rate us",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            content: Text(
              "Thank you for supporting cal! Please rate us in the app store.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
    );
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
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7E0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'My Profile',
                    style: TextStyle(fontSize: 24, color: Color(0xFF16151A)),
                  ),
                ),
                const SizedBox(height: 35),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: _openAvatarSelection,
                      child: Container(
                        width: 148,
                        height: 148,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF292D33),
                          image: DecorationImage(
                            image: AssetImage(_avatarPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 100,
                      top: 0,
                      child: Container(
                        width: 16,
                        height: 17,
                        decoration: const BoxDecoration(
                          color: Color(0xFF242833),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_firstName $_lastName',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xFF16151A),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _openEditProfile,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9A0104),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFDF7E0),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16151A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Your grade',
                          style: TextStyle(
                            color: Color(0xFFFDF7E0),
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBD751),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Beginner',
                              style: TextStyle(
                                color: Color(0xFF16151A),
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTapDown: (details) {
                                final RenderBox button =
                                    context.findRenderObject() as RenderBox;
                                final Offset buttonPosition = button
                                    .localToGlobal(Offset.zero);

                                showMenu(
                                  context: context,
                                  position: RelativeRect.fromLTRB(
                                    buttonPosition.dx,
                                    buttonPosition.dy + button.size.height,
                                    buttonPosition.dx + button.size.width,
                                    buttonPosition.dy +
                                        button.size.height +
                                        300,
                                  ),
                                  items: [
                                    PopupMenuItem(
                                      enabled: false,
                                      child: Container(
                                        width: 203,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFDF7E0),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'You will be given a title for entries over a period of time.',
                                              style: TextStyle(
                                                color: Color(0xFF16151A),
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Container(
                                              height: 1,
                                              color: const Color(0xFF16151A),
                                            ),
                                            const SizedBox(height: 6),
                                            const Text(
                                              'Beginner - For entries within 5 days',
                                              style: TextStyle(
                                                color: Color(0xFFDEAF00),
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            const Text(
                                              'Advanced - For entries within 14 days',
                                              style: TextStyle(
                                                color: Color(0xFFEE7700),
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            const Text(
                                              'Experienced - For entries within 35 days',
                                              style: TextStyle(
                                                color: Color(0xFF8EAF3C),
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            const Text(
                                              'Pro - For entries within 90 days',
                                              style: TextStyle(
                                                color: Color(0xFF548BA5),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              child: Container(
                                width: 19,
                                height: 19,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF16151A),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    '?',
                                    style: TextStyle(
                                      color: Color(0xFF16151A),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'About app',
                          style: TextStyle(
                            color: Color(0xFFFDF7E0),
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSettingsButton('Edit Profile', _openEditProfile),
                      const SizedBox(height: 10),
                      _buildSettingsButton('Rate us', _handleRate),
                      const SizedBox(height: 10),
                      _buildSettingsButton(
                        'Privacy Policy',
                        _openPrivacyPolicy,
                      ),
                      const SizedBox(height: 10),
                      _buildSettingsButton('About us', _openAboutUs),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF7E0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Color(0xFF16151A), fontSize: 17),
          ),
        ),
      ),
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF1A5F7A).withOpacity(0.1)
          ..style = PaintingStyle.fill;

    // Рисуем волны
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.6,
      size.width * 0.5,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.7,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // Добавляем точки
    final dotPaint =
        Paint()
          ..color = const Color(0xFF1A5F7A).withOpacity(0.2)
          ..style = PaintingStyle.fill;

    for (var i = 0; i < 20; i++) {
      final x = size.width * (i / 20);
      final y = size.height * (0.3 + (i % 2) * 0.1);
      canvas.drawCircle(Offset(x, y), 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(BackgroundPatternPainter oldDelegate) => false;
}
