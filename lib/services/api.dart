import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:nelo/models/chapter.dart';
import 'package:nelo/models/manga.dart';

class API {
  static const url_base = "https://manganelo.com";
  static const url_active = "https://tenz.surge.sh/manganelo.json";

  static Future getMangaList({required String sort, int page = 1}) async {
    var response =
        await http.get(Uri.parse("$url_base/genre-all/$page?type=$sort"));
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      final container =
          document.getElementsByClassName("panel-content-genres").first;

      final list = container.getElementsByClassName("content-genres-item");
      return list.map((e) => Manga.toManga(e)).toList();
    }
  }

  static Future getMangaDetails(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      final container =
          document.getElementsByClassName("story-info-right").first;
      return Details.toDetails(container);
    }
  }

  static Future getMangaChapters(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      final container =
          document.getElementsByClassName("row-content-chapter").first;
      final list = container.getElementsByClassName("a-h");

      return list.map((e) => Chapter.toChapter(e)).toList();
    }
  }

  static Future getChapterImages(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      final container =
          document.getElementsByClassName("container-chapter-reader").first;
      final images = container.getElementsByTagName("img");
      return images.map((e) => e.attributes["src"]).toList();
    }
  }

  static Future getSearchQuery(String q) async {
    var response = await http
        .get(Uri.parse("$url_base/search/story/${q.replaceAll(' ', '_')}"));
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      final container =
          document.getElementsByClassName("panel-search-story").first;

      final list = container.getElementsByClassName("search-story-item");
      return list.map((e) => Manga.fromSearch(e)).toList();
    }
  }
}
