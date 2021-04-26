import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocktail/models/drink.dart';
import 'package:cocktail/models/drink_detail.dart';
import 'package:cocktail/models/favorite.dart';
import 'package:cocktail/models/recent.dart';
import 'package:cocktail/ultils/faded_page_route.dart';
import 'package:flutter/material.dart';
import 'package:cocktail/pages/details_page.dart';

class PreviewList extends StatefulWidget {
  final String previewLabel;
  const PreviewList({Key key, this.previewLabel}) : super(key: key);
  @override
  _PreviewListState createState() => _PreviewListState();
}

class _PreviewListState extends State<PreviewList> {
  ScrollController _scrollController;
  String description;
  List drinks, favorites, recents;
  DrinkDetail drinkDetail;
  String oldDrinkId;
  @override
  void initState() {
    favorites = [];
    Favorite.fetchAll().then(_setFavorites);
    recents = [];
    Recent.fetchAll().then(_setRecents);
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(
      () {
        var newDrinkId = drinks[(_scrollController.offset / 350).round()].id;
        if (oldDrinkId != newDrinkId) {
          oldDrinkId = newDrinkId;
          _showDrinkDetail(oldDrinkId);
        }
      },
    );
  }

  _setFavorites(List data) {
    setState(() {
      favorites = data;
    });
  }

  _setRecents(List data) {
    setState(() {
      recents = data;
    });
  }

  _showDrinkDetail(String drinkId) {
    if (drinkId == null) return;
    DrinkDetail.fetch(drinkId).then(
      (DrinkDetail detail) {
        print("Fetched Values");
        setState(() {
          drinkDetail = detail;
        });
      },
      onError: (e) {
        print('Couldnt get data for id ' + drinkId + ' Error ' + e.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          height: 350,
          child: FutureBuilder(
            future: Drink.fetch(listType: 'ALL'),
            builder: (
              BuildContext context,
              AsyncSnapshot<List> snapshot,
            ) {
              if (snapshot.hasData) {
                drinks = snapshot.data;
                print(widget.previewLabel);
                if(widget.previewLabel == 'FAVORITES'){
                  print(favorites);
                  drinks = drinks.where((d) => favorites.contains(d.id)).toList();
                } else if(widget.previewLabel == 'VIEWED'){
                  drinks = drinks.where((d) => recents.contains(d.id)).toList();
                }
                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: drinks.length,
                  itemBuilder: (context, index) {
                    Drink drink = drinks[index] as Drink;
                    return _childPreview(context, drink);
                  },
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 10),
                        child: Text('Awaiting result...'),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child: _detailSection(drinkDetail),
        ),
      ],
    );
  }

  Widget _childPreview(BuildContext context, Drink drink) {
    return Stack(
      children: <Widget>[
        Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: const EdgeInsets.all(15),
          child: CachedNetworkImage(
              imageUrl: drink.url,
              placeholder: (context, url) => CircularProgressIndicator(),
              fit: BoxFit.fill),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        Container(
          width: 345,
          child: Align(
            alignment: Alignment(0.1, -1),
            child: Text(
              drink.name,
              style: TextStyle(color: Colors.deepOrangeAccent),
            ),
          ),
        ),
        Container(
          width: 345,
          child: Align(
            alignment: Alignment(0.9, -0.9),
            child: IconButton(
              onPressed: () {
                if (favorites.contains(drink.id)) {
                  Favorite.delete(drink.id).then(_setFavorites);
                } else {
                  Favorite.add(drink.id).then(_setFavorites);
                }
              },
              icon: Icon(
                (favorites.contains(drink.id)
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
        Container(
          width: 345,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              heroTag: drink.name + widget.previewLabel,
              elevation: 0,
              onPressed: () {
                Navigator.push(
                  context,
                  FadedPageRoute(
                    widget: DetailsPage(
                      id: drink.id,
                      name: drink.name,
                      url: drink.url,
                    ),
                  ),
                );
                print("Tapped " + drink.name);
              },
              backgroundColor: Colors.deepOrangeAccent,
              child: Icon(
                Icons.local_bar,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _detailSection(DrinkDetail drinkDetail) {
    if (drinkDetail == null) return Container();
    var ingredients = drinkDetail.ingredientsList();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SelectableText(
            drinkDetail.name,
            style: TextStyle(
              color: Colors.deepOrangeAccent,
              fontSize: 24,
              letterSpacing: 2,
            ),
            cursorColor: Colors.orange,
            showCursor: true,
            toolbarOptions: ToolbarOptions(
              copy: true,
              selectAll: true,
            ),
          ),
          Text(
            "\nIngredients: ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SelectableText(
            ingredients.join('\n'),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              letterSpacing: 2,
            ),
            cursorColor: Colors.orange,
            showCursor: true,
            toolbarOptions: ToolbarOptions(
              copy: true,
              selectAll: true,
            ),
          ),
          Text(
            "\nInstructions: ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SelectableText(
            drinkDetail.instructions,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              letterSpacing: 2,
            ),
            cursorColor: Colors.orange,
            showCursor: true,
            toolbarOptions: ToolbarOptions(
              copy: true,
              selectAll: true,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
              child: FlatButton.icon(
            padding: const EdgeInsets.all(10),
            color: Colors.deepOrangeAccent,
            onPressed: () {
              Navigator.push(
                context,
                FadedPageRoute(
                  widget: DetailsPage(
                    id: drinkDetail.id,
                    name: drinkDetail.name,
                    url: drinkDetail.url,
                  ),
                ),
              );
            },
            label: Text(
              'VIEW',
              style: TextStyle(color: Colors.black),
            ),
            icon: Icon(
              Icons.local_bar,
              color: Colors.white,
            ),
          ))
        ]);
  }
}
