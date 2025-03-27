import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SharedPrefsService {
  // Ключи
  static const _kSavedFirstName = 'user_firstName';
  static const _kSavedLastName = 'user_lastName';
  static const _kSavedAge = 'user_age';
  static const _kSavedWeight = 'user_weight';
  static const _kSavedEmail = 'user_email';
  static const _kSavedPassword = 'user_password';
  static const _kSavedAvatar = 'user_avatar'; // Если нужно хранить аватар

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Создаём (регистрируем) пользователя.
  /// Если email уже зарегистрирован, вернёт false.
  static Future<bool> createUser({
    required String firstName,
    required String lastName,
    required String age,
    required String weight,
    required String email,
    required String password,
    String avatarPath = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final hashedPassword = _hashPassword(password);

    // Проверяем, не занято ли это мейлом
    final existingEmail = prefs.getString(_kSavedEmail);
    if (existingEmail == email) {
      // Пользователь с таким email уже зарегистрирован
      return false;
    }

    // Сохраняем данные
    await prefs.setString(_kSavedFirstName, firstName);
    await prefs.setString(_kSavedLastName, lastName);
    await prefs.setString(_kSavedAge, age);
    await prefs.setString(_kSavedWeight, weight);
    await prefs.setString(_kSavedEmail, email);
    await prefs.setString(_kSavedPassword, hashedPassword);

    if (avatarPath.isNotEmpty) {
      await prefs.setString(_kSavedAvatar, avatarPath);
    }

    return true;
  }

  /// Вход по email и паролю
  static Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final hashedPassword = _hashPassword(password);

    final savedEmail = prefs.getString(_kSavedEmail);
    final savedPassword = prefs.getString(_kSavedPassword);

    return savedEmail == email && savedPassword == hashedPassword;
  }

  /// Выход из аккаунта
  static Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    // Очищаем все данные пользователя при выходе
    await prefs.remove(_kSavedFirstName);
    await prefs.remove(_kSavedLastName);
    await prefs.remove(_kSavedAge);
    await prefs.remove(_kSavedWeight);
    await prefs.remove(_kSavedEmail);
    await prefs.remove(_kSavedPassword);
    await prefs.remove(_kSavedAvatar);
  }

  /// Читаем профиль
  static Future<Map<String, String?>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'firstName': prefs.getString(_kSavedFirstName),
      'lastName': prefs.getString(_kSavedLastName),
      'age': prefs.getString(_kSavedAge),
      'weight': prefs.getString(_kSavedWeight),
      'email': prefs.getString(_kSavedEmail),
      'avatar': prefs.getString(_kSavedAvatar),
    };
  }

  /// Обновить профиль (если нужно менять отдельно)
  static Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    required String age,
    required String weight,
    String? avatarPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSavedFirstName, firstName);
    await prefs.setString(_kSavedLastName, lastName);
    await prefs.setString(_kSavedAge, age);
    await prefs.setString(_kSavedWeight, weight);

    if (avatarPath != null && avatarPath.isNotEmpty) {
      await prefs.setString(_kSavedAvatar, avatarPath);
    }
  }
}

class ProfileService {
  static const _kNameKey = 'profile_name';
  static const _kAgeKey = 'profile_age';
  static const _kWeightKey = 'profile_weight';
  static const _kAvatarPathKey = 'profile_avatar_path';

  // Сохранить данные профиля
  static Future<void> saveProfile({
    required String name,
    required String age,
    required String weight,
    required String avatarPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kNameKey, name);
    await prefs.setString(_kAgeKey, age);
    await prefs.setString(_kWeightKey, weight);
    await prefs.setString(_kAvatarPathKey, avatarPath);
  }

  // Загрузить данные профиляa
  static Future<Map<String, String?>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_kNameKey),
      'age': prefs.getString(_kAgeKey),
      'weight': prefs.getString(_kWeightKey),
      'avatarPath': prefs.getString(_kAvatarPathKey),
    };
  }
}
