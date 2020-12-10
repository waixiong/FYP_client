import 'package:hive/hive.dart';

part '_main.g.dart';

@HiveType(typeId: 0)
class Message {
  @HiveField(1)
  String text;

  @HiveField(0)
  String id;

  Message({this.id, this.text});
}

void main() async {
  Hive.init('./test/hive');
  Hive.registerAdapter<Message>(MessageAdapter());
  await Hive.openBox<Message>('message');
  var b = Hive.box<Message>('message');
  // await b.add(Message(id: 'z', text: 'aa'));
  // await b.add(Message(id: 'c', text: 'bb'));
  // await b.add(Message(id: 'j', text: 'cc'));
  // await b.add(Message(id: 'k', text: 'dd'));
  for(var m in b.keys.toList()) {
    print(m);
  }
  b.close();
}