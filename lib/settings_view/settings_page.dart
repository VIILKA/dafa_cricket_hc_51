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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1E3D59),
              const Color(0xFF1E3D59).withOpacity(0.8),
              const Color(0xFF17C3B2).withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Верхняя панель с профилем
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFFFD700).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ValueListenableBuilder<Box<UserProfile>>(
                    valueListenable: Hive.box<UserProfile>('user').listenable(),
                    builder: (context, box, _) {
                      final user = box.get('current_user');
                      return GestureDetector(
                        onTap: () {
                          if (user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EditProfilePage(
                                      initialName: user.firstName,
                                      initialSurname: user.lastName,
                                      initialAge: user.level,
                                      initialEmail: user.email,
                                      initialAvatarPath: user.avatarPath,
                                    ),
                              ),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF1E3D59),
                                    const Color(0xFF17C3B2).withOpacity(0.8),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 26,
                                  backgroundImage: AssetImage(
                                    user?.avatarPath.isNotEmpty == true
                                        ? user!.avatarPath
                                        : 'assets/images/avatar.png',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Profile Settings',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user?.firstName.isNotEmpty == true
                                        ? user!.firstName
                                        : 'User',
                                    style: const TextStyle(
                                      color: Color(0xFF2D3142),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.grey[400]),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Секция настроек
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSettingItem(
                        context,
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        subtitle: 'Change your profile information',
                        onTap: _openEditProfile,
                      ),
                      _buildSettingItem(
                        context,
                        icon: Icons.lock_outline,
                        title: 'Privacy Policy',
                        subtitle: 'Read our privacy policy',
                        onTap: _openPrivacyPolicy,
                      ),
                      _buildSettingItem(
                        context,
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        subtitle: 'Get help and contact support',
                        onTap: _openContactUs,
                      ),
                      _buildSettingItem(
                        context,
                        icon: Icons.info_outline,
                        title: 'About',
                        subtitle: 'Learn more about the app',
                        onTap: _openAboutUs,
                      ),
                      _buildSettingItem(
                        context,
                        icon: Icons.share_outlined,
                        title: 'Share App',
                        subtitle: 'Share with friends and family',
                        onTap: _handleShare,
                      ),
                      _buildSettingItem(
                        context,
                        icon: Icons.star_outline,
                        title: 'Rate Us',
                        subtitle: 'Rate us on the app store',
                        onTap: _handleRate,
                      ),
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

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3D59).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF1E3D59), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
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
