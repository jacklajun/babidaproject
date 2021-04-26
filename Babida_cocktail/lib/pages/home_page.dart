import 'package:cocktail/pages/listing_page.dart';
import 'package:cocktail/ultils/faded_page_route.dart';
import 'package:cocktail/ultils/preview_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 4,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () {
                    Navigator.push(
                      context,
                      FadedPageRoute(
                        widget: ListingPage(),
                      ),
                    );
                  },
                  color: Colors.black,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.settings),
                  color: Colors.black,
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TabBar(
            controller: tabController,
            isScrollable: true,
            tabs: <Widget>[
              Text(
                'ALL',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              Text(
                'FAVORITES',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              Text(
                'VIEWED',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: MediaQuery.of(context).size.height - 200,
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                PreviewList(previewLabel: 'ALL'),
                PreviewList(previewLabel: 'FAVORITES'),
                PreviewList(previewLabel: 'VIEWED'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
