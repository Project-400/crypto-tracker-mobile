import 'dart:core';

class BotLog {

  String log;
  DateTime time;

  BotLog(
      this.log,
      this.time
  );

  BotLog.fromJson(Map<String, dynamic> json): log = json['log'], time = DateTime.parse(json['time']);

}
