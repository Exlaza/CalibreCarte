abstract class Storage {
  Future<String> read(String key);
  Future<void> write(String key, String value);
  Future<bool> containsKey(String key);
  Future<void> delete(String key);
}