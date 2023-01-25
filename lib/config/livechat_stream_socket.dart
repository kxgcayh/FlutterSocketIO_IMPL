import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_socketio/models/chat_model.dart';

class LiveChatStreamSocket {
  LiveChatStreamSocket() {
    if (!_socketResponse.isClosed) init();
  }

  List<ChatMessageModel> values = [];
  void init() async {
    final response = await Dio().get(
      '{initial_chat_list_uri}',
    );
    response.data.forEach((json) {
      values.add(ChatMessageModel.fromJson(json));
    });
    _socketResponse.sink.add(values);
  }

  final _socketResponse = StreamController<List<ChatMessageModel>>();

  void Function(List<ChatMessageModel> items) get addResponse {
    return _socketResponse.sink.add;
  }

  void updateItems(ChatMessageModel item) {
    _socketResponse.sink.add([...values, item]);
  }

  Stream<List<ChatMessageModel>> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}
