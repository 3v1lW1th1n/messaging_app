import 'package:flutter/material.dart';
import 'package:backendless_sdk/backendless_sdk.dart'; 
import 'package:backendless_sdk/src/modules/modules.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _messages = "";
  final myController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    Backendless.initApp(
      "61AE8EEB-EA13-15FB-FF48-9197C8FD0500", 
      "71CC3603-33A7-3238-FF0A-37B4B983EE00", 
      "77CCF20A-A5AB-FF09-FFFC-710027274900");
    initListeners();
  }

  void initListeners() async {
    Channel channel = await Backendless.Messaging.subscribe("myChannel");
    channel.addMessageListener(onMessageReceived);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void onMessageSubmitted(String message) async {
    Backendless.Messaging.publish(message, channelName: "myChannel", 
      publishOptions: PublishOptions()..headers = {"name":"Maksym"});
    myController.clear();
  }

  void onMessageReceived(PublishMessageInfo messageInfo) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(messageInfo.timestamp);
    setState(() => _messages += "${time.hour}:${time.minute}:${time.second} ${messageInfo.headers['name']}: ${messageInfo.message}\n");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft, 
            child: Text("$_messages")
          ),
          Align(
            alignment: Alignment.bottomLeft, 
            child: TextField(
              onSubmitted: onMessageSubmitted,
              controller: myController,
              decoration: InputDecoration(
                fillColor: Colors.black12, filled: true
              ),
            ),
          ),
        ],
      ),
    );
  }
}
