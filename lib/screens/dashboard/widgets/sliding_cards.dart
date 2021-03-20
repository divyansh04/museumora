import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:museumora/models/show_data.dart';
import 'dart:math' as math;
import 'package:museumora/screens/PaymentCheckout.dart';
import 'package:museumora/screens/virtual_tour/views/screens/floorplan_screen.dart';

class SlidingCardsView extends StatefulWidget {
  @override
  _SlidingCardsViewState createState() => _SlidingCardsViewState();
}

class _SlidingCardsViewState extends State<SlidingCardsView> {
  PageController pageController;
  double pageOffset = 0;
  List<ShowData> showsList;
  QuerySnapshot shows;
  bool gotData = false;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page);
    });
    getShows();
  }

  getShows() async {
    shows = await _fireStore
        .collection('shows')
        .orderBy("imageKey", descending: false)
        .get();
    setState(() {
      gotData = true;
    });
    print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii" + "${shows.docs.length}");
    //  showsList = shows.docs as List<ShowData>;
    // ShowData.fromJson(shows.docs.;
    //showsList.forEach((element) {
    // print('oooooooooooooooooooooooooooo' + element.cityName);
    //});
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !gotData
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator(), Text('Loading Data')],
            ),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: PageView.builder(
                itemCount: shows.docs.length,
                controller: pageController,
                itemBuilder: (BuildContext context, int itemIndex) {
                  return SlidingCard(
                    name: shows.docs[itemIndex]['title'],
                    timings: shows.docs[itemIndex]['timings'],
                    description: shows.docs[itemIndex]['description'],
                    assetName: shows.docs[itemIndex]['imageKey'] == 1
                        ? 'images/steve-johnson.jpeg'
                        : shows.docs[itemIndex]['imageKey'] == 2
                            ? 'images/efe-kurnaz.jpg'
                            : 'images/rodion-kutsaev.jpeg',
                    offset: pageOffset - itemIndex,
                    price: shows.docs[itemIndex]['price'],
                    cityName: shows.docs[itemIndex]['cityName'],
                    imageKey: shows.docs[itemIndex]['imageKey'],
                  );
                }),
          );
  }
}

class SlidingCard extends StatelessWidget {
  final String name;
  final String description;
  final String assetName;
  final double offset;
  final String timings;
  final int price;
  final String cityName;
  final int imageKey;

  const SlidingCard(
      {Key key,
      @required this.name,
      @required this.description,
      @required this.assetName,
      @required this.offset,
      @required this.price,
      @required this.timings,
      this.cityName,
      this.imageKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Card(
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              child: Image.asset(
                'assets/$assetName',
                height: MediaQuery.of(context).size.height * 0.3,
                alignment: Alignment(-offset.abs(), 0),
                fit: BoxFit.none,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: CardContent(
                name: name,
                details: description,
                offset: gauss,
                price: price,
                imageUrl: 'assets/$assetName',
                cityName: cityName,
                imageKey: imageKey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardContent extends StatefulWidget {
  final String name;
  final String details;
  final String imageUrl;
  final double offset;
  final String timings;
  final int price;
  final String cityName;
  final int imageKey;
  const CardContent({
    Key key,
    this.timings,
    this.name,
    this.details,
    this.imageUrl,
    this.offset,
    this.price,
    this.cityName,
    this.imageKey,
  }) : super(key: key);

  @override
  _CardContentState createState() => _CardContentState();
}

class _CardContentState extends State<CardContent> {
  bool fav = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * widget.offset, 0),
            child: Text(widget.name, style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(32 * widget.offset, 0),
            child: Text(
              widget.details,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(48 * widget.offset, 0),
                child: RaisedButton(
                  color: Color(0xFF162A49),
                  child: Transform.translate(
                    offset: Offset(24 * widget.offset, 0),
                    child: Text('Reserve'),
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentCheckout(
                                  name: widget.name,
                                  details: widget.details,
                                  amount: widget.price.toDouble(),
                                  imageUrl: widget.imageUrl,
                                  cityName: widget.cityName,
                                  imageKey: widget.imageKey,
                                )));
                  },
                ),
              ),
              Spacer(),
              Transform.translate(
                offset: Offset(32 * widget.offset, 0),
                child: Text(
                  ' ₹ ${widget.price}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    setState(() {
                      fav = !fav;
                    });
                  },
                  icon: Icon(
                    fav ? Icons.favorite : Icons.favorite_outline,
                    color: Colors.red,
                    size: 28,
                  )),
              SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }
}
