import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart' as constants;

class ResultPage extends StatefulWidget {
  final String item;
  final Function callback;

  const ResultPage({Key? key, required this.item, required this.callback})
      : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: const Color(constants.whiteColor),
          appBar: AppBar(
            title: const Text('Link:'),
            backgroundColor: const Color(constants.mainColor),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => {widget.callback(), Navigator.pop(context)},
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.item),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(constants.mainColor),
                        ),
                        child: const Text('Redirect'),
                        onPressed: () => {launch(widget.item)},
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(constants.mainColor),
                        ),
                        child: const Text('Close'),
                        onPressed: () =>
                            {widget.callback(), Navigator.pop(context)},
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Future<bool> _onBackPressed() {
    widget.callback();
    return Future<bool>.value(true);
  }
}
