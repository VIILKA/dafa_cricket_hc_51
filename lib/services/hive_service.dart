import 'package:dafa_cricket/core/models/affirmation_model.dart';
import 'package:dafa_cricket/core/models/emotion_model.dart';
import 'package:dafa_cricket/core/models/user_model.dart';
import 'package:dafa_cricket/core/models/trigger_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static const String emotionsBoxName = 'emotions';
  static const String affirmationsBoxName = 'affirmations';
  static const String userBoxName = 'user';
  static const String triggersBoxName = 'triggers';

  static Future<void> initHive() async {
    await Hive.initFlutter();

    // Регистрация адаптеров
    Hive.registerAdapter(EmotionRecordAdapter());
    Hive.registerAdapter(AffirmationRecordAdapter());
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(TriggerListAdapter());

    // Открытие боксов
    await Hive.openBox<EmotionRecord>(emotionsBoxName);
    await Hive.openBox<AffirmationRecord>(affirmationsBoxName);
    await Hive.openBox<UserProfile>(userBoxName);
    await Hive.openBox<TriggerList>(triggersBoxName);
  }
}
