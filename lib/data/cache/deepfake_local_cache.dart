import 'package:shared_preferences/shared_preferences.dart';

class DeepfakeLocalCache {
  static const String lastJobIdKey = 'last_job_id';

  const DeepfakeLocalCache();

  Future<String?> getLastJobId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastJobIdKey);
  }

  Future<void> saveLastJobId(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastJobIdKey, jobId);
  }

  Future<void> clearLastJobId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(lastJobIdKey);
  }
}
