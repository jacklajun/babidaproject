import 'package:cocktail/models/recent.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/drink_detail.dart';
import '../ultils/detail_top_clipper.dart';

class DetailsPage extends StatelessWidget {
  final String id, url, name;

  const DetailsPage({
    Key key,
    this.id,
    this.url,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Recent.add(id);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: DetailTopClippper(),
                    child: Container(
                      color: Colors.white,
                      child: CachedNetworkImage(
                        imageUrl: url,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: FloatingActionButton(
                      mini: true,
                      elevation: 0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              FutureBuilder(
                future: DrinkDetail.fetch(id),
                builder: (context, AsyncSnapshot<DrinkDetail> snapshot) {
                  if (snapshot.hasData) {
                    DrinkDetail drinkDetail = snapshot.data;

                    var ingredients = drinkDetail.ingredientsList();
                    var onlyIngredients = drinkDetail.ingredientsOnlyList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SelectableText(
                            drinkDetail.name,
                            style: TextStyle(
                              color: Colors.black,
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
                              fontFamily: "Arial",
                            ),
                          ),
                          SelectableText(
                            ingredients.join('\n'),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              letterSpacing: 2,
                              fontFamily: "Arial",
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
                              fontFamily: "Arial",
                            ),
                          ),
                          SelectableText(
                            drinkDetail.instructions,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              letterSpacing: 2,
                              fontFamily: "Arial",
                            ),
                            cursorColor: Colors.orange,
                            showCursor: true,
                            toolbarOptions: ToolbarOptions(
                              copy: true,
                              selectAll: true,
                            ),
                          ),
                          Text(
                            "\nSearch Items based on: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Arial",
                            ),
                          ),
                          Wrap(
                            spacing: 8.0, // gap between adjacent chips
                            runSpacing: 0, // gap between lines
                            children: <Widget>[
                              Chip(
                                label: Text(drinkDetail.category),
                              ),
                              Chip(
                                label: Text(drinkDetail.glass),
                              ),
                              ...onlyIngredients.map(
                                (i) {
                                  return Chip(
                                    label: Text(i),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Error: ${snapshot.error}'),
                        )
                      ],
                    );
                  }
                  return SelectableText(
                    name,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                      letterSpacing: 2,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
