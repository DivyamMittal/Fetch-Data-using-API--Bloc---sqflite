import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../database/database_helper.dart';
import '../models/user_model.dart';

class APIs {
  final String apiUrl = 'https://jsonplaceholder.typicode.com/users';

  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final db = await DatabaseHelper.instance.database;
      final batch = db.batch();

      for (var userJson in data) {
        UserModel user = UserModel.fromJson(userJson);
        batch.insert('user', user.toJson());
      }

      try {
        await batch.commit();
      } catch (e) {
        print('Error inserting data into the database: $e');
      }

      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
