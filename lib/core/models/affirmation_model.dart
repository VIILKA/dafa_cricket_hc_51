import 'package:hive/hive.dart';

part 'affirmation_model.g.dart';

@HiveType(typeId: 1)
class AffirmationRecord {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final bool isFavorite;

  @HiveField(3)
  final List<DateTime> completionDates;

  AffirmationRecord({
    required this.id,
    required this.text,
    this.isFavorite = false,
    this.completionDates = const [],
  });
}
