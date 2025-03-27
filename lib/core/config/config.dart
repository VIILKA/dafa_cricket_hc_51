import 'package:dafa_cricket/core/btm.dart';
import 'package:dafa_cricket/core/onb/onb_pages/onb_page_widget.dart';
import 'package:dafa_cricket/screens/affirmations_screen.dart';
import 'package:dafa_cricket/screens/home_screen.dart';
import 'package:dafa_cricket/screens/statistics_screen.dart';

import 'package:dafa_cricket/settings_view/settings_page.dart';
import 'package:flutter/material.dart';

final List<Widget> tamplateOnbList = [
  const TamplateOnbPageWidget(
    image: 'assets/images/onb1.png',
    title: 'Track Your Mood',
    description:
        'Record your daily emotions and track your mood patterns over time',
  ),
  const TamplateOnbPageWidget(
    image: 'assets/images/onb2.png',
    title: 'Get Insights',
    description:
        'Receive personalized insights and recommendations based on your mood data',
  ),
  const TamplateOnbPageWidget(
    image: 'assets/images/onb3.png',
    title: 'Improve Well-being',
    description:
        'Take steps to improve your mental health with guided exercises and tips',
  ),
  const TamplateOnbPageWidget(
    image: 'assets/images/onb4.png',
    title: 'Stay Motivated',
    description:
        'Get daily affirmations and motivational content to maintain a positive mindset',
  ),
];

final List<PageModel> tamplatePages = [
  PageModel(
    page: HomeScreen(),
    iconPath: 'assets/images/house.png',
    title: 'Home',
  ),
  PageModel(
    page: StatisticsScreen(),
    iconPath: 'assets/images/message-text.png',
    title: 'Statistics',
  ),
  PageModel(
    page: AffirmationsScreen(),
    iconPath: 'assets/images/chart.png',
    title: 'Affirmations',
  ),

  PageModel(
    page: const SettingsPage(),
    iconPath: 'assets/images/cup.png',
    title: 'Profile',
  ),
];
