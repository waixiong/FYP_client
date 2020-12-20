import 'package:hive/hive.dart';

part '_main.g.dart';

@HiveType(typeId: 0)
class Message {
  @HiveField(1)
  String text;

  @HiveField(0)
  String id;

  @HiveField(2)
  DateTime date;

  Message({this.id, this.text, this.date});
}

void main() async {
  Hive.init('./test/hive');
  Hive.registerAdapter<Message>(MessageAdapter());
  await Hive.openBox<Message>('message2');
  var b = Hive.box<Message>('message2');
  // b.clear();
  // await b.add(Message(id: 'z', text: 'aa'));
  // await b.add(Message(id: 'c', text: 'bb'));
  // await b.add(Message(id: 'j', text: 'cc'));
  // await b.add(Message(id: 'k', text: 'dd'));
  // Message m;
  // var time = DateTime.now().millisecondsSinceEpoch;
  // m = Message(id: 'z', text: 'aa', date: DateTime.fromMillisecondsSinceEpoch(time - 28587));
  // await b.put(m.date.millisecondsSinceEpoch.toRadixString(16) + m.id, m);
  // m = Message(id: 'c', text: 'bb', date: DateTime.fromMillisecondsSinceEpoch(time + 33334));
  // await b.put(m.date.millisecondsSinceEpoch.toRadixString(16) + m.id, m);
  // m = Message(id: 'q', text: 'cc', date: DateTime.fromMillisecondsSinceEpoch(time));
  // await b.put(m.date.millisecondsSinceEpoch.toRadixString(16) + m.id, m);
  // m = Message(id: 'aa', text: 'dd', date: DateTime.fromMillisecondsSinceEpoch(time - 123456));
  // await b.put(m.date.millisecondsSinceEpoch.toRadixString(16) + m.id, m);
  await b.put('1764fde1a40z', null);
  for(var m in b.keys.toList()) {
    print(m);
    b.get(m);
    print(b.get(m));
  }
  b.close();

  var list = [2, 1, 4, 5, 3];
  list.sort((a, b) {
    return b - a;
  });
  print(list);
}