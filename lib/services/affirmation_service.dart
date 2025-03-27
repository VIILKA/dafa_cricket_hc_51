import 'package:dafa_cricket/core/models/affirmation_model.dart';
import 'package:dafa_cricket/services/hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AffirmationService {
  final Box<AffirmationRecord> _affirmationsBox;

  AffirmationService()
    : _affirmationsBox = Hive.box(HiveService.affirmationsBoxName);

  Future<void> toggleFavorite(String id) async {
    final affirmation = _affirmationsBox.values.firstWhere((a) => a.id == id);

    final updatedAffirmation = AffirmationRecord(
      id: affirmation.id,
      text: affirmation.text,
      isFavorite: !affirmation.isFavorite,
      completionDates: affirmation.completionDates,
    );

    final index = _affirmationsBox.values.toList().indexOf(affirmation);
    await _affirmationsBox.putAt(index, updatedAffirmation);
  }

  Future<void> markAsCompleted(String id) async {
    final affirmation = _affirmationsBox.values.firstWhere((a) => a.id == id);

    final updatedDates = [...affirmation.completionDates, DateTime.now()];

    final updatedAffirmation = AffirmationRecord(
      id: affirmation.id,
      text: affirmation.text,
      isFavorite: affirmation.isFavorite,
      completionDates: updatedDates,
    );

    final index = _affirmationsBox.values.toList().indexOf(affirmation);
    await _affirmationsBox.putAt(index, updatedAffirmation);
  }

  List<AffirmationRecord> getAllAffirmations() {
    return _affirmationsBox.values.toList();
  }
}
