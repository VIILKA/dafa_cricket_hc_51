import 'package:hive_flutter/hive_flutter.dart';
import 'package:dafa_cricket/core/models/emotion_model.dart';

class EmotionService {
  static const String boxName = 'emotions';

  Future<void> addEmotion(EmotionRecord emotion) async {
    final box = Hive.box<EmotionRecord>(boxName);
    await box.add(emotion);
  }

  Map<String, int> getEmotionStats(bool isWeekly) {
    final box = Hive.box<EmotionRecord>(boxName);
    final now = DateTime.now();
    final startDate =
        isWeekly
            ? now.subtract(const Duration(days: 7))
            : now.subtract(const Duration(days: 30));

    final emotions = box.values.where((e) => e.date.isAfter(startDate));

    final stats = <String, int>{};
    for (var emotion in emotions) {
      stats[emotion.emotion] = (stats[emotion.emotion] ?? 0) + 1;
    }

    return stats;
  }

  int getTotalEmotions() {
    final box = Hive.box<EmotionRecord>(boxName);
    return box.length;
  }

  List<EmotionRecord> getEmotionsForDate(DateTime date) {
    final box = Hive.box<EmotionRecord>(boxName);
    return box.values
        .where(
          (e) =>
              e.date.year == date.year &&
              e.date.month == date.month &&
              e.date.day == date.day,
        )
        .toList();
  }
}
