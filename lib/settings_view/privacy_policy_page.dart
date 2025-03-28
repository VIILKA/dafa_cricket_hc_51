import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Color scheme
    const Color primaryBlue = Color(0xFF1E3D59);
    const Color secondaryBlue = Color(0xFF17C3B2);
    const Color goldLight = Color(0xFFFFD700);
    const Color goldDark = Color(0xFFDAA520);
    const Color surfaceColor = Colors.white;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryBlue,
              primaryBlue.withOpacity(0.8),
              secondaryBlue.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
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
                      'Privacy Policy',
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

              // Main content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('About Our App'),
                        _buildSectionText(
                          'We are committed to protecting your privacy and ensuring the security of your emotional well-being data. This privacy policy explains how we collect, use, and safeguard your information while you use our mood tracking application.',
                        ),

                        const SizedBox(height: 24),
                        _buildSectionTitle('1. Information We Collect'),
                        _buildSectionSubtitle('Personal Information'),
                        _buildBulletPoint('Name and contact details'),
                        _buildBulletPoint(
                          'Profile information (age, preferences)',
                        ),
                        _buildBulletPoint('Mood tracking data and patterns'),
                        _buildBulletPoint('Usage statistics and achievements'),

                        const SizedBox(height: 16),
                        _buildSectionSubtitle('Emotional Data'),
                        _buildBulletPoint(
                          'Daily mood entries and emotional states',
                        ),
                        _buildBulletPoint('Trigger lists and patterns'),
                        _buildBulletPoint('Personal notes and reflections'),
                        _buildBulletPoint('App usage patterns and preferences'),

                        const SizedBox(height: 24),
                        _buildSectionTitle('2. How We Use Your Information'),
                        _buildBulletPoint(
                          'To provide personalized mood tracking',
                        ),
                        _buildBulletPoint(
                          'To analyze emotional patterns and trends',
                        ),
                        _buildBulletPoint(
                          'To improve our emotional wellness features',
                        ),
                        _buildBulletPoint(
                          'To send relevant notifications and reminders',
                        ),
                        _buildBulletPoint(
                          'To generate wellness insights and reports',
                        ),

                        const SizedBox(height: 24),
                        _buildSectionTitle('3. Data Security'),
                        _buildBulletPoint(
                          'We implement industry-standard encryption',
                        ),
                        _buildBulletPoint(
                          'Your data is stored securely on your device',
                        ),
                        _buildBulletPoint(
                          'Regular security audits and updates',
                        ),
                        _buildBulletPoint(
                          'Protection against unauthorized access',
                        ),

                        const SizedBox(height: 24),
                        _buildSectionTitle('4. Data Sharing'),
                        _buildBulletPoint(
                          'We do not sell your personal information',
                        ),
                        _buildBulletPoint(
                          'We do not share your data with third parties',
                        ),
                        _buildBulletPoint(
                          'Your emotional data remains private',
                        ),
                        _buildBulletPoint(
                          'Optional participation in anonymous statistics',
                        ),

                        const SizedBox(height: 24),
                        _buildSectionTitle('5. Your Rights'),
                        _buildBulletPoint('Access your personal data'),
                        _buildBulletPoint('Correct inaccurate information'),
                        _buildBulletPoint('Delete your account'),
                        _buildBulletPoint('Export your tracking history'),

                        const SizedBox(height: 24),
                        _buildSectionTitle('6. Changes to This Policy'),
                        _buildSectionText(
                          'We may update this privacy policy to reflect changes in our practices or legal requirements. We will notify you of any significant changes through the app.',
                        ),

                        const SizedBox(height: 24),
                        _buildSectionText(
                          'For any privacy-related questions, please contact us at privacy@dafacricket.com',
                        ),
                      ],
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

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3142),
        ),
      ),
    );
  }

  Widget _buildSectionSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3142),
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Color(0xFF4E5D78)),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4E5D78),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF4E5D78)),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

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
                    'About Us',
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

            // Основной текст
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16151A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20.0,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Need help or have questions about our mood tracking app?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFDF7E0),
                          ),
                        ),

                        const SizedBox(height: 16),
                        const Text(
                          '''We're here to support your emotional wellness journey! Contact us through any of these channels:''',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFDF7E0),
                          ),
                        ),

                        const SizedBox(height: 20),
                        _buildContactItem('📧 Email:', 'support@cal.edu'),
                        _buildContactItem('🌐 Website:', 'www.cal.edu'),
                        _buildContactItem(
                          '📱 In-app support:',
                          'Available 24/7',
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          'Our support team is ready to help you with:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFDF7E0),
                          ),
                        ),

                        const SizedBox(height: 10),
                        _buildBulletPoint('Mood tracking questions'),
                        _buildBulletPoint('Technical issues'),
                        _buildBulletPoint('Account management'),
                        _buildBulletPoint('App features and usage'),
                        _buildBulletPoint('General inquiries'),

                        const SizedBox(height: 20),
                        _buildContactItem(
                          'Response time:',
                          'Within 24 hours during business days',
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

  Widget _buildContactItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFDF7E0),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Color(0xFFFDF7E0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFFDF7E0),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFFFDF7E0)),
            ),
          ),
        ],
      ),
    );
  }
}
