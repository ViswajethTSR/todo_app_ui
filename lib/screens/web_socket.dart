import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../custom_designs/custom_app_bar.dart';

const wsIP = '64.227.166.14';
const wsPORT = 1800;

class WebSocket extends StatefulWidget {
  @override
  _WebSocketState createState() => _WebSocketState();
}

class _WebSocketState extends State<WebSocket> {
  final channel = IOWebSocketChannel.connect('ws://$wsIP:$wsPORT');
  final List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarForNormalPage('Web Socket Datas'),
      body: buildBody(),
      floatingActionButton: buildSendDataButton(),
    );
  }

  FloatingActionButton buildSendDataButton() {
    return FloatingActionButton(
      onPressed: () {
        channel.sink.add('Hello, WebSocket Server!');
      },
      tooltip: 'Send Message',
      child: const Icon(Icons.send),
    );
  }

  Widget buildBody() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text(messages[index]),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(messages.isEmpty ? 'Connecting...' : 'Received Messages:'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    channel.stream.listen((message) {
      setState(() {
        messages.add(message);
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
