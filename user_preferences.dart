/*import 'dart:convert';
import 'package:healme/User/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserPreferences {
  static late SharedPreferences _preferences;
  static const _keyUser = 'user';
  static const myUser = User1(

    email: "example@gmail.com",
    name: "Username",
    type: "Patient",
    imagePath:
        '',
  );

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future setUser (User1 user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser,json);
  }

  static User1 getUser(){
    final json = _preferences.getString(_keyUser);
    return json == null ? myUser : User1.fromJson(jsonDecode(json));
  }
}
*/