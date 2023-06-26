import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';

import 'get_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Bit X change'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  price controller = Get.put(price());
  final btcChannel = IOWebSocketChannel.connect(
      "wss://stream.binance.com:9443/ws/btcusdt@trade");
  final ethChannel = IOWebSocketChannel.connect(
      "wss://stream.binance.com:9443/ws/ethusdt@trade");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serviceListener();
  }

  void serviceListener() {
    btcChannel.stream.listen((event) {
      Map mp = jsonDecode(event);

      controller.bitChange(mp['p']);

      // print(event);
    });
    ethChannel.stream.listen((event) {
      Map mp = jsonDecode(event);

      controller.ethChange(mp['p']);

      // print(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(1.toString());
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.s,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Bitcoin Price: ',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            Obx(
              () => Text(
                "\$ ${double.parse(controller.bitPrice.value).toStringAsFixed(2)}",
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            const Text(
              'Eth Price: ',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            Obx(
              () => Text(
                "\$ ${double.parse(controller.ethPrice.value).toStringAsFixed(3)}",
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
