class Message {
  final String text;

  Message({required this.text});

  factory Message.fromJson(String text) {
    return Message(text: text);
  }
}
