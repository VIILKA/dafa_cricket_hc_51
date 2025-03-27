import 'package:dafa_cricket/core/models/user_model.dart';
import 'package:dafa_cricket/services/hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserService {
  final Box<UserProfile> _userBox;

  UserService() : _userBox = Hive.box(HiveService.userBoxName);

  Future<void> updateProfile(UserProfile profile) async {
    await _userBox.put('current_user', profile);
  }

  UserProfile? getCurrentUser() {
    return _userBox.get('current_user');
  }

  String getUserLevel() {
    final user = getCurrentUser();
    if (user == null) return 'beginner';
    return user.level;
  }
}
