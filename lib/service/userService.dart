import 'package:increment/database/repository.dart';
import '../database/create_db.dart';

class userService {
  late Repository _repository;

  userService() {
    _repository = Repository();
  }

  Future<bool> doesUserExist(String userName) async {
    var connection = await _repository.database;
    var result = await connection?.query(
      'login',
      where: 'userName = ?',
      whereArgs: [userName],
    );
    return result != null && result.isNotEmpty;
  }

  Future<Login?> getUserByUsername(String userName) async {
    var connection = await _repository.database;
    var result = await connection?.query(
      'login',
      where: 'userName = ?',
      whereArgs: [userName],
    );
    if (result != null && result.isNotEmpty) {
      return Login.fromMap(result.first);
    }
    return null;
  }

  Future<int?> getUserCount(String userName) async {
    var connection = await _repository.database;
    var result = await connection?.query(
      'user_counts',
      where: 'user_id = ?',
      whereArgs: [userName],
    );
    if (result != null && result.isNotEmpty) {
      return result.first['count'] as int?;
    } else {
      // If user count does not exist, create an entry with count = 0
      await addUserCount(userName);
      return 0;
    }
  }

  Future<void> updateUserCount(String userName, int newCount) async {
    var connection = await _repository.database;
    await connection?.update(
      'user_counts',
      {'count': newCount},
      where: 'user_id = ?',
      whereArgs: [userName],
    );
  }

  Future<void> addUserCount(String userName) async {
    var connection = await _repository.database;
    await connection?.insert(
      'user_counts',
      {'user_id': userName, 'count': 0}, // Initializing count to 0
    );
  }

  saveUserDetails(Login login) async {
    return await _repository.insertData("login", login.toMap());
  }

  readAllTable() async {
    return await _repository.readData('login');
  }
}
