import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 2)
class UserProfile {
  @HiveField(0)
  final String firstName;

  @HiveField(1)
  final String lastName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String avatarPath;

  @HiveField(4)
  final String level;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarPath,
    this.level = 'beginner',
  });
}
