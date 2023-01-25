import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_socketio/config/livechat_stream_socket.dart';
import 'package:flutter_socketio/models/chat_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IO.Socket socket;
  bool isConnected = false;
  String socketServer = '{socket_server}';
  LiveChatStreamSocket streamSocket = LiveChatStreamSocket();

  @override
  void initState() {
    socket = IO.io(
      socketServer,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );
    socketConfiguration();
    super.initState();
  }

  void socketConfiguration() {
    socket.onConnect((data) {
      log('socket connected to: $socketServer, data($data) with Id: ${socket.id}');
      setState(() => isConnected = true);
    });
    socket.onDisconnect((data) {
      log('socket disconnected from: $socketServer, data($data)');
      setState(() => isConnected = false);
    });
    socket.on('chat message', (data) {
      final chat = ChatMessageModel.fromSocket(data);
      streamSocket.updateItems(chat);
    });
  }

  void sendMessage() {
    socket.emit(
      'chat message',
      {
        'text': 'At: ${DateTime.now()}',
        'username': 'kautsaralbana',
        'id': '{room_id}',
        'source': '{source_name}',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiveChat - [free_cast - 69]'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessageModel>>(
              stream: streamSocket.getResponse,
              builder: (
                BuildContext context,
                AsyncSnapshot<List<ChatMessageModel>> snapshot,
              ) {
                if (snapshot.data != null) {
                  List<ChatMessageModel> data = snapshot.data!;
                  return SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.map((chat) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${chat.userName}:',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Chat: ${chat.text}'),
                              const SizedBox(height: 10),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (!isConnected) {
                socket.connect();
              } else {
                socket.disconnect();
              }
            },
            child: Text(
              !isConnected ? 'Connect Socket' : 'Disconnect Socket',
            ),
          ),
          if (isConnected)
            ElevatedButton(
              onPressed: () => sendMessage(),
              child: const Text('SEND'),
            ),
        ],
      ),
    );
  }
}
