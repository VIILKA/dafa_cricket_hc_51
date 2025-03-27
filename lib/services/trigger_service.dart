import 'package:hive_flutter/hive_flutter.dart';
import 'package:dafa_cricket/core/models/trigger_model.dart';

class TriggerService {
  static const String boxName = 'triggers';

  late Box<TriggerList> _box;

  TriggerService() {
    _box = Hive.box<TriggerList>(boxName);
  }

  Future<void> saveTriggerList(TriggerList triggerList) async {
    await _box.add(triggerList);
  }

  List<TriggerList> getAllTriggerLists() {
    return _box.values.toList();
  }

  TriggerList? getTriggerListById(String id) {
    try {
      return _box.values.firstWhere((list) => list.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteTriggerList(String id) async {
    final index = _box.values.toList().indexWhere((list) => list.id == id);
    if (index != -1) {
      await _box.deleteAt(index);
    }
  }

  bool hasAnyTriggerLists() {
    return _box.isNotEmpty;
  }
}
