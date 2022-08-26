import 'package:html/dom.dart' as dom;

class Manga {
  String? title;
  String? views;
  String? date;
  String? rating;
  String? url;
  String? description;
  String? poster;

  Manga.toManga(dom.Element element) {
    title = element.getElementsByTagName("h3").first.text;
    poster = element.getElementsByTagName("img").first.attributes["src"];
    views = element.getElementsByClassName("genres-item-view").first.text;
    date = element.getElementsByClassName("genres-item-time").first.text;
    url = element.getElementsByTagName("a").first.attributes["href"];
    description =
        element.getElementsByClassName("genres-item-description").first.text;
  }

  Manga.fromSearch(dom.Element e) {
    title = e.querySelector("a")!.attributes["title"];
    url = e.querySelector("a")!.attributes["href"];
    poster = e.querySelector("a > img")!.attributes["src"];
    date = e.querySelectorAll("div > span")[0].text;
    views = e.querySelectorAll("div > span")[1].text;
  }

  Manga.fromJson(Map<dynamic, dynamic> json)
      : title = json['title'],
        poster = json['poster'],
        date = json['date'],
        views = json['views'],
        description = json['description'],
        url = json['url'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'poster': poster,
        'date': date,
        'views': views,
        'description': description,
        'url': url,
      };
}

class Details {
  List<String>? key, value;
  List<String>? key1, value1;

  Details.toDetails(dom.Element element) {
    key = element
        .getElementsByClassName("table-label")
        .map((e) => e.text)
        .toList();
    value = element
        .getElementsByClassName("table-value")
        .map((e) => e.text.trim())
        .toList();
    key1 = element
        .getElementsByClassName("stre-label")
        .map((e) => e.text)
        .toList();
    value1 = element
        .getElementsByClassName("stre-value")
        .map((e) => e.text.trim())
        .toList();
    var rating = element
        .querySelector('#rate_row_cmd')!
        .text
        .replaceAll('  ', '')
        .replaceAll('\n', '')
        .replaceAll(RegExp('^[^:]+:\s*'), '');
    value1!.last = rating;
  }
}
