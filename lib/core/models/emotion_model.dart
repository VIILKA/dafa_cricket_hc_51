import 'package:hive/hive.dart';

part 'emotion_model.g.dart';

@HiveType(typeId: 0)
class EmotionRecord {
  @HiveField(0)
  final String emotion;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final List<String>? reasons;

  @HiveField(3)
  final String? comment;

  @HiveField(4)
  final String? triggerList;

  EmotionRecord({
    required this.emotion,
    required this.date,
    this.reasons,
    this.comment,
    this.triggerList,
  });
}
