import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'trigger_model.g.dart';

@HiveType(typeId: 3)
class TriggerList extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> triggers;

  @HiveField(3)
  final String? comment;

  @HiveField(4)
  final DateTime createdAt;

  TriggerList({
    String? id,
    required this.name,
    required this.triggers,
    this.comment,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();
}
