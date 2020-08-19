import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_tracker/models/coin.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CryptoBotScreen extends StatefulWidget {
  CryptoBotScreen({Key key, this.title}) : super(key: key);

  final String title;
  final WebSocketChannel channel = IOWebSocketChannel.connect('ws://ec2-3-250-75-62.eu-west-1.compute.amazonaws.com:8999');

  @override
  _CryptoBotScreenState createState() => _CryptoBotScreenState();
}

class _CryptoBotScreenState extends State<CryptoBotScreen> {

  bool isBotWorking = false;
  String botError = '';

  @override
  void initState() {
    super.initState();
    checkBotStatus();

    widget.channel.stream.listen((received) {
      print(received);
//      Map<String, dynamic> data = jsonDecode(received);
      _sortData(received);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: this.botError.length > 0,
              child: Text(this.botError),
            ),
            Text('The Market Bot is${this.isBotWorking ? '' : ' not'} working right now.'),
            FlatButton(
              child: Text(this.isBotWorking ? 'Stop Bot' : 'Start Bot'),
              onPressed: () {
                if (this.isBotWorking) this.stopBot();
                else this.startBot();
              },
              color: Colors.lightBlue,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _sortData(String msg) {
    print(msg);
  }

  Future<http.Response> checkBotStatus() async {
    final response = await http.get('http://ec2-3-250-75-62.eu-west-1.compute.amazonaws.com:3000/v1/bot-status');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      setState(() => this.isBotWorking = data['botWorking']);
    } else {
      throw Exception('Failed to fetch Bot status');
    }
  }

  Future<http.Response> startBot() async {
    final response = await http.get('http://ec2-3-250-75-62.eu-west-1.compute.amazonaws.com:3000/v1/start-bot');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        if (!data.containsKey('message')) this.botError = 'Failed to start bot';
        else this.isBotWorking = true;
      });
    } else {
      throw Exception('Failed to start Bot');
    }
  }

  Future<http.Response> stopBot() async {
    final response = await http.get('http://ec2-3-250-75-62.eu-west-1.compute.amazonaws.com:3000/v1/stop-bot');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        if (!data.containsKey('message')) this.botError = 'Failed to stop bot';
        else this.isBotWorking = false;
      });
    } else {
      throw Exception('Failed to stop Bot');
    }
  }
}
