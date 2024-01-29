import 'dart:convert';

class Player {
  int id = 0;
  String name;
  int score;
  int time;

  Player(this.name, this.score, this.time,{this.id = 0});


  factory Player.fromJson(Map<String,dynamic> json) {
    return Player(json['name'], json['score'], json['time'],id: json['id']);
  }
  Map<String,dynamic> toJson() {
    return {
      'name': name,
      'score': score,
      'time': time
    };
  }
}