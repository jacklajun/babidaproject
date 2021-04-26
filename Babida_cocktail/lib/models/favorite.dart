import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Favorite {
  final String id;

  Favorite(this.id);

  static Box _box;
  static Future _openBox() async {
    if (_box != null) return;

    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    _box = await Hive.openBox('favoritesBox');
    return;
  }

  static Future<List> fetchAll() async {
    _openBox();
    if (_box != null) {
      print(" All Favorites from Box.. ");
      return _box.toMap().values.toList();
    } else {
      return [];
    }
  }

  static Future<List> add(String id) async {
    _openBox();
    if (_box != null) {
      print("Storing id " + id + " to Box.. ");
      _box.put(id, id);
      print(_box.toMap().values.toList());
      return _box.toMap().values.toList();
    } else {
      return [];
    }
  }

  static Future<List> delete(String id) async {
    _openBox();
    if (_box != null) {
      print("Deleting id " + id + " from Box.. ");
      _box.delete(id);
      return _box.toMap().values.toList();
    } else {
      return [];
    }
  }
}
