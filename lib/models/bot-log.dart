import 'dart:core';

class BotLog {

  String log;
  String type;
  DateTime time;

  BotLog(
      this.log,
      this.type,
      this.time
  );

  BotLog.fromJson(Map<String, dynamic> json):
        log = json['log'],
        type = json['type'],
        time = DateTime.parse(json['time']);

}
