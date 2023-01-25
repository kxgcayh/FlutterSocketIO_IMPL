class ChatMessageModel {
  const ChatMessageModel({
    this.chatId,
    this.roomId,
    required this.text,
    required this.userName,
    required this.source,
    this.ip,
    this.date,
  });

  final String? chatId;
  final String? roomId;
  final String text;
  final String userName;
  final String source;
  final DateTime? date;
  final String? ip;

  static ChatMessageModel fromSocket(dynamic data) {
    return ChatMessageModel(
      roomId: data["id"],
      text: data["text"],
      userName: data["username"],
      source: data["source"],
    );
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        chatId: json["_id"],
        userName: json["username"],
        text: json["text"],
        source: json["source"],
        date: json["date"] != null ? DateTime.parse(json["date"]) : null,
        ip: json["ip"],
        roomId: json["id"],
      );

  @override
  String toString() {
    return 'ChatMessageModel(chatId: $chatId, roomId: $roomId,text: $text, userName: $userName, source: $source)';
  }
}
