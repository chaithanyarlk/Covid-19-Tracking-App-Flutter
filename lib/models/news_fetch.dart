import 'package:maverick_red_2245/models/news_model.dart';

class News_List {
  List<Todaynews> news_list;
  News_List({this.news_list});
  factory News_List.fromJson(Map<String, dynamic> json) {
    var data = json['articles'];
    print("came");
    print(data.toString());
    print(data.length);
    List<Todaynews> news = new List<Todaynews>();
    var t = data.length;
    if (data.length > 20) {
      t = 20;
    }
    for (int i = 0; i < t; i++) {
      print(data[i]['source']['id']);
      print(data[i]['source']['name']);
      print(data[i]['title']);
      print(data[i]['url']);
      print(data[i]['urlToImage']);
      print(data[i]['publishedAt']);
      print(data[i]['content']);
      print(i);
      news.add(
        Todaynews(
          source_id: data[i]['source']['id'],
          source_name: data[i]['source']['name'],
          title: data[i]['title'],
          url: data[i]['url'],
          imageurl: data[i]['urlToImage'],
          date: data[i]['publishedAt'],
          content: data[i]['content'],
        ),
      );
    }
    print(news.toList());
    return News_List(
      news_list: news,
    );
  }
}
