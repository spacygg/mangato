import 'package:html/dom.dart' as dom;

class Chapter {
  String? title;
  String? views;
  String? uploaded;
  String? url;
  Chapter.toChapter(dom.Element element) {
    title = element.getElementsByClassName("chapter-name").first.text;
    views = element.getElementsByClassName("chapter-view").first.text;
    uploaded = element.getElementsByClassName("chapter-time").first.text;
    url = element.getElementsByTagName("a").first.attributes["href"];
  }
  Map<String, dynamic> toJson() => {
        'title': title,
        'views': views,
        'uploaded': uploaded,
        'url': url,
      };
}
