import 'dart:convert';

ShowData showDataFromJson(String str) => ShowData.fromJson(json.decode(str));

String showDataToJson(ShowData data) => json.encode(data.toJson());

class ShowData {
  String title;
  String description;
  String timings;
  String cityName;
  String imageKey;
  String price;

  ShowData({
    this.imageKey,
    this.cityName,
    this.price,
    this.description,
    this.timings,
    this.title,
  });
  factory ShowData.fromJson(Map<String, dynamic> json) => ShowData(
      imageKey: json["imageKey"],
      cityName: json["cityName"],
      price: json["price"],
      description: json["description"],
      timings: json["timings"],
      title: json["title"]);

  Map<String, dynamic> toJson() => {
        "imageKey": imageKey,
        "cityName": cityName,
        "price": price,
        "description": description,
        "timings": timings,
        "title": title,
      };

  // Map toMap(ShowData shows) {
  //   var data = Map<String, dynamic>();
  //   data['title'] = shows.title;
  //   data['description'] = shows.description;
  //   data['timings'] = shows.timings;
  //   data['imageKey'] = shows.imageKey;
  //   data['price'] = shows.price;
  //   data['cityName'] = shows.cityName;
  //   return data;
  // }

  // // Named constructor
  // ShowData.fromMap(Map<String, dynamic> mapData) {
  //   this.title = mapData['title'];
  //   this.cityName = mapData['cityName'];
  //   this.description = mapData['description'];
  //   this.imageKey = mapData['imageKey'];
  //   this.price = mapData['price'];
  //   this.timings = mapData['timings'];
  // }
}
