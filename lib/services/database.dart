import 'package:nelo/models/chapter.dart';
import 'package:nelo/models/manga.dart';
import 'package:sqflite/sqflite.dart';

class BookmarkHandler {
  late Database db;

  Future open() async {
    db = await openDatabase('manganato.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table bookmark ( 
  title text,
  views text,
  date text,
  rating text,
  url text primary key,
  description text,
  poster text
  )
''');

      await db.execute('''
create table watched ( 
  title text,
  views text,
  uploaded text,
  url text primary key
  )
''');
    });
  }

  Future<Chapter> insertEp(Chapter episode) async {
    await open();
    await db.insert('watched', episode.toJson());
    return episode;
  }

  Future<int> deleteEp(Chapter episode) async {
    await open();
    return await db
        .delete('watched', where: 'url = ?', whereArgs: [episode.url]);
  }

  Future<bool> isWatched({required Chapter episode}) async {
    await open();
    List<Map> maps = await db.query('watched',
        columns: ['title', 'views', 'uploaded', 'url'],
        where: 'url = ?',
        whereArgs: [episode.url]);
    return maps.isNotEmpty;
  }

  Future<Manga> insert(Manga anime) async {
    await open();
    await db.insert('bookmark', anime.toJson());
    return anime;
  }

  Future<bool> isBookmarked({required Manga anime}) async {
    await open();
    List<Map> maps = await db.query('bookmark',
        columns: ['title', 'poster', 'date', 'views', 'url', 'description'],
        where: 'url = ?',
        whereArgs: [anime.url]);
    return maps.isNotEmpty;
  }

  Future<List<Manga>> getBookmarks() async {
    await open();
    List<Map> maps = await db.query(
      'bookmark',
      columns: [
        'title',
        'views',
        'date',
        'rating',
        'url',
        'description',
        'poster'
      ],
    );
    return maps.map((e) => Manga.fromJson(e)).toList();
  }

  Future<int> delete(Manga anime) async {
    await open();
    return await db
        .delete('bookmark', where: 'url = ?', whereArgs: [anime.url]);
  }

  Future close() async => db.close();
}
