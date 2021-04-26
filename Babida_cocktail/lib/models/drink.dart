import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';


class Drink {
  final String name;
  final String url;
  final String id;

  Drink({
    this.name,
    this.url,
    this.id,
  });

  factory Drink._fromJson(Map<String, dynamic> json) {
    return Drink(
      name: json['strDrink'],
      url: json['strDrinkThumb'],
      id: json['idDrink'],
    );
  }

  static final String _cocktailURL =
      'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail';


  static Box _box;
  static Future _openBox() async {
    if(_box != null) return;

    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    _box = await Hive.openBox('drinkingBox');
    return;
  }

  static Future<List> fetch({ listType = 'ALL'}) async {
    _openBox();
      if(_box != null && _box.toMap().length > 0) {
        print("Fetching from Box.. " + listType);
        return convertJsonData(_box.get(listType));
      } else {
        var client = new http.Client();
        try {
          var response = await client.get(_cocktailURL);
          if (response.statusCode == 200) {
            // If server returns an OK response, parse the JSON.
            print("Fetching from API.. " + listType);
            _box.put(listType, response.body);
            return convertJsonData(response.body);
          } else {
            // If that response was not OK, throw an error.
            throw Exception('Failed to load cocktails..');
          }
        } finally {
          client.close();
        }
      }
  }

  static convertJsonData(body) {
    // If server returns an OK response, parse the JSON.
    List<dynamic> drinks = json.decode(
      body,
    )['drinks'];

    return drinks.map((data) => Drink._fromJson(data)).toList();
  }
}
