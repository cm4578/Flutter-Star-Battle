import 'dart:async';
import 'package:flutter_star_battle/model/player.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String _rankTable = 'rank';

class SqlHelper {
  static final SqlHelper _instance = SqlHelper.internal();

  SqlHelper.internal();

  factory SqlHelper() {
    return _instance;
  }

  Future<Database> _init() async {
    final dbPath = join(await getDatabasesPath(), 'starBattle.db');
    final db = await openDatabase(dbPath, onCreate: (db, version) async {
      await db.execute(
          'create table if not exists $_rankTable ('
              'id integer primary key autoincrement,'
              'name text not null,'
              'score integer not null,'
              'time integer not null)');
    }, version: 1);
    return db;
  }

  Future addRankData(Player player) async {
    var db = await _init();
    await db.insert(_rankTable, player.toJson());
  }

  Future<List<Player>> getAllRankData() async {
    var db = await _init();
    return (await db.rawQuery('select * from rank order by score desc'))
        .map((e) => Player.fromJson(e))
        .toList();
  }
}
