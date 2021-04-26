import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DrinkDetail {
  final String name;
  final String url;
  final String id;
  final String nameAlternate;
  final String tags;
  final String video;
  final String category;
  final String iba; // Identification and Brief Advice
  final String alcoholic;
  final String glass;
  final String instructions;
  final String ingredients1;
  final String ingredients2;
  final String ingredients3;
  final String ingredients4;
  final String ingredients5;
  final String ingredients6;
  final String ingredients7;
  final String ingredients8;
  final String ingredients9;
  final String ingredients10;
  final String ingredients11;
  final String ingredients12;
  final String ingredients13;
  final String ingredients14;
  final String ingredients15;
  final String measure1;
  final String measure2;
  final String measure3;
  final String measure4;
  final String measure5;
  final String measure6;
  final String measure7;
  final String measure8;
  final String measure9;
  final String measure10;
  final String measure11;
  final String measure12;
  final String measure13;
  final String measure14;
  final String measure15;
  final String creativeCommonsConfirmed;
  final String dateModified;

  DrinkDetail(
      {this.name,
      this.url,
      this.id,
      this.nameAlternate,
      this.tags,
      this.video,
      this.category,
      this.iba,
      this.alcoholic,
      this.glass,
      this.instructions,
      this.ingredients1,
      this.ingredients2,
      this.ingredients3,
      this.ingredients4,
      this.ingredients5,
      this.ingredients6,
      this.ingredients7,
      this.ingredients8,
      this.ingredients9,
      this.ingredients10,
      this.ingredients11,
      this.ingredients12,
      this.ingredients13,
      this.ingredients14,
      this.ingredients15,
      this.measure1,
      this.measure2,
      this.measure3,
      this.measure4,
      this.measure5,
      this.measure6,
      this.measure7,
      this.measure8,
      this.measure9,
      this.measure10,
      this.measure11,
      this.measure12,
      this.measure13,
      this.measure14,
      this.measure15,
      this.creativeCommonsConfirmed,
      this.dateModified});

  factory DrinkDetail._fromJson(Map<String, dynamic> json) {
    return DrinkDetail(
      id: json["idDrink"],
      name: json["strDrink"],
      nameAlternate: json["strDrinkAlternate"],
      tags: json["strTags"],
      video: json["strVideo"],
      category: json["strCategory"],
      iba: json["strIBA"], // Identification and Brief Advice
      alcoholic: json["strAlcoholic"],
      glass: json["strGlass"],
      instructions: json["strInstructions"],
      url: json["strDrinkThumb"],
      ingredients1: json["strIngredient1"],
      ingredients2: json["strIngredient2"],
      ingredients3: json["strIngredient3"],
      ingredients4: json["strIngredient4"],
      ingredients5: json["strIngredient5"],
      ingredients6: json["strIngredient6"],
      ingredients7: json["strIngredient7"],
      ingredients8: json["strIngredient8"],
      ingredients9: json["strIngredient9"],
      ingredients10: json["strIngredient10"],
      ingredients11: json["strIngredient11"],
      ingredients12: json["strIngredient12"],
      ingredients13: json["strIngredient13"],
      ingredients14: json["strIngredient14"],
      ingredients15: json["strIngredient15"],
      measure1: json["strMeasure1"],
      measure2: json["strMeasure2"],
      measure3: json["strMeasure3"],
      measure4: json["strMeasure4"],
      measure5: json["strMeasure5"],
      measure6: json["strMeasure6"],
      measure7: json["strMeasure7"],
      measure8: json["strMeasure8"],
      measure9: json["strMeasure9"],
      measure10: json["strMeasure10"],
      measure11: json["strMeasure11"],
      measure12: json["strMeasure12"],
      measure13: json["strMeasure13"],
      measure14: json["strMeasure14"],
      measure15: json["strMeasure15"],
      creativeCommonsConfirmed: json["strCreativeCommonsConfirmed"],
      dateModified: json["dateModified"],
    );
  }

  List<String> ingredientsList() {
    return [
      (ingredients1 ?? '') + " - " + (measure1 ?? ''),
      (ingredients2 ?? '') + " - " + (measure2 ?? ''),
      (ingredients3 ?? '') + " - " + (measure3 ?? ''),
      (ingredients4 ?? '') + " - " + (measure4 ?? ''),
      (ingredients5 ?? '') + " - " + (measure5 ?? ''),
      (ingredients6 ?? '') + " - " + (measure6 ?? ''),
      (ingredients7 ?? '') + " - " + (measure7 ?? ''),
      (ingredients8 ?? '') + " - " + (measure8 ?? ''),
      (ingredients9 ?? '') + " - " + (measure9 ?? ''),
      (ingredients10 ?? '') + " - " + (measure10 ?? ''),
      (ingredients11 ?? '') + " - " + (measure11 ?? ''),
      (ingredients12 ?? '') + " - " + (measure12 ?? ''),
      (ingredients13 ?? '') + " - " + (measure13 ?? ''),
      (ingredients14 ?? '') + " - " + (measure14 ?? ''),
      (ingredients15 ?? '') + " - " + (measure15 ?? ''),
    ]..removeWhere((value) => value == " - ");
  }

  List<String> ingredientsOnlyList() {
    return [
      ingredients1,
      ingredients2,
      ingredients3,
      ingredients4,
      ingredients5,
      ingredients6,
      ingredients7,
      ingredients8,
      ingredients9,
      ingredients10,
      ingredients11,
      ingredients12,
      ingredients13,
      ingredients14,
      ingredients15,
    ]..removeWhere((value) => value == null);
  }

  static Box _box;
  static Future _openBox() async {
    if (_box != null) return;

    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    _box = await Hive.openBox('drinkDetailsBox');
    return;
  }

  static final String _cocktailURL =
      'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=';
  static Future<DrinkDetail> fetch(String id) async {
    _openBox();
    if (_box != null && _box.get(id) != null) {
      print("Fetching from Box.. " + id);
      return convertJsonData(_box.get(id));
    } else {
      var client = new http.Client();
      try {
        var response = await client.get(_cocktailURL + id);
        if (response.statusCode == 200) {
          // If server returns an OK response, parse the JSON.
          print("Fetching from API.. " + id);
          _box.put(id, response.body);
          return convertJsonData(response.body);
        } else {
          // If that response was not OK, throw an error.
          throw Exception('Failed to load cocktails..');
        }
      } catch (e) {
        throw Exception('Failed to load cocktails.. Exception');
      } finally {
        client.close();
      }
    }
  }

  static convertJsonData(body) {
    Map<String, dynamic> drink = json.decode(body)['drinks'][0];
    return DrinkDetail._fromJson(drink);
  }
}
