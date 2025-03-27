import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                    'Privacy Policy',
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
                        _buildSectionTitle('Privacy Policy'),
                        _buildSectionText(
                          'At cal, we are committed to protecting your privacy and ensuring the security of your personal information. This privacy policy explains how we collect, use, and safeguard your data while you use our application.',
                        ),

                        const SizedBox(height: 16),
                        _buildSectionTitle('1. Information We Collect'),
                        _buildSectionSubtitle('Personal Information'),
                        _buildBulletPoint(
                          'Name and contact details (email address)',
                        ),
                        _buildBulletPoint('Profile information (age, weight)'),
                        _buildBulletPoint('Mood tracking data and preferences'),
                        _buildBulletPoint('Usage statistics and achievements'),

                        const SizedBox(height: 10),
                        _buildSectionSubtitle('Activity Data'),
                        _buildBulletPoint('Mood entries and emotional states'),
                        _buildBulletPoint('Trigger lists and patterns'),
                        _buildBulletPoint('Comments and notes you create'),
                        _buildBulletPoint('App usage statistics'),

                        const SizedBox(height: 16),
                        _buildSectionTitle('2. How We Use Your Information'),
                        _buildBulletPoint(
                          'To provide personalized mood tracking',
                        ),
                        _buildBulletPoint('To show statistics and insights'),
                        _buildBulletPoint(
                          'To improve our emotional wellness content',
                        ),
                        _buildBulletPoint(
                          'To send notifications about your tracking',
                        ),
                        _buildBulletPoint('To generate wellness analytics'),

                        const SizedBox(height: 16),
                        _buildSectionTitle('3. Data Security'),
                        _buildBulletPoint(
                          'We implement industry-standard security measures',
                        ),
                        _buildBulletPoint(
                          'Your data is stored locally on your device',
                        ),
                        _buildBulletPoint(
                          'We use encryption to protect sensitive information',
                        ),
                        _buildBulletPoint(
                          'Regular security audits are performed',
                        ),

                        const SizedBox(height: 16),
                        _buildSectionTitle('4. Data Sharing'),
                        _buildBulletPoint(
                          'We do not sell your personal information',
                        ),
                        _buildBulletPoint(
                          'We do not share your data with third parties',
                        ),
                        _buildBulletPoint(
                          'All your emotional data stays on your device',
                        ),

                        const SizedBox(height: 16),
                        _buildSectionTitle('5. Your Rights'),
                        _buildBulletPoint('Access your personal data'),
                        _buildBulletPoint('Correct inaccurate information'),
                        _buildBulletPoint('Request data deletion'),
                        _buildBulletPoint('Export your tracking data'),

                        const SizedBox(height: 16),
                        _buildSectionTitle('6. Changes to This Policy'),
                        _buildSectionText(
                          'We may update this privacy policy to reflect changes in our practices or legal requirements. We will notify you of any significant changes.',
                        ),

                        const SizedBox(height: 16),
                        _buildSectionText(
                          'For any privacy-related questions, please contact us at privacy@cal.edu',
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

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFDF7E0),
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
          color: Color(0xFFFDF7E0),
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Color(0xFFFDF7E0)),
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
