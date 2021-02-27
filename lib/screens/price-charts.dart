import 'package:flutter/material.dart';

class PriceChartsScreen extends StatefulWidget {
  PriceChartsScreen({ Key key, this.title }) : super(key: key);

  final String title;

  @override
  _PriceChartsScreenState createState() => _PriceChartsScreenState();
}

class _PriceChartsScreenState extends State<PriceChartsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Price Charts')
                ]
            ),
          ),
        ),
      );
  }

}
