import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/drink.dart';
import '../ultils/faded_page_route.dart';
import 'details_page.dart';
import 'package:cocktail/models/favorite.dart';

class ListingPage extends StatefulWidget {
  @override
  _ListingPageState createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  List<Drink> displayedDrinks = [], allDrinks = [];
  List favorites;

  @override
  void initState() {
    print("Inside Init...");

    favorites = [];
    Favorite.fetchAll().then(_setFavorites);

    Drink.fetch().then(
      (List drinks) {
        print("Fetched Values");
        allDrinks = drinks;
        setState(() {
          displayedDrinks = drinks;
        });
      },
      onError: (e) {
        setState(() {
          displayedDrinks = [];
        });
      },
    );
    super.initState();
  }

  _setFavorites(List data) {
    setState(() {
      favorites = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0), // here the desired height
          child: AppBar(
            titleSpacing: 20.0,
            title: TextField(
              onChanged: (query) {
                if (query == '') {
                  setState(() {
                    displayedDrinks.addAll(allDrinks);
                  });
                } else {
                  List<Drink> newList = [];
                  allDrinks.forEach((item) {
                    if (item.name.toLowerCase().contains(query.toLowerCase())) {
                      newList.add(item);
                    }
                  });
                  setState(() {
                    displayedDrinks = newList;
                  });
                }
                print(query);
              },
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                contentPadding: const EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.orange.shade100,
            elevation: 0,
          ),
        ),
        body: (displayedDrinks.length == 0 ? _noResults() : _results()));
  }

  Widget _results() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: displayedDrinks.length,
      itemBuilder: (context, index) {
        Drink drink = displayedDrinks[index];
        return Container(
          decoration: new BoxDecoration(
            color: Colors.orange.shade100,
            border: new Border(
              bottom: new BorderSide(
                color: Colors.orange.shade100,
              ),
            ),
          ),
          child: ListTile(
            leading: CachedNetworkImage(
              imageUrl: drink.url,
              placeholder: (context, url) => CircularProgressIndicator(),
            ),
            trailing: IconButton(
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
            title: Text(drink.name),
            subtitle: SizedBox(
              height: 10,
            ),
            onTap: () {
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
          ),
        );
      },
    );
  }

  Widget _noResults() {
    return Column(
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
          child: Text('Loading...'),
        )
      ],
    );
  }
}
