import 'package:chatty/messagesScreen.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(brightness: Brightness.light),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Chatter Box"),
          centerTitle: true,
        ),
        body: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DialogFlowtter
      _dialogFlowtter; // late Initialization of the dialogflowtter

  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];
  // aik list jismay Map aye yani {:} aur isme first string ho second kuch bhi hoskta hai so dynamic lelia

  @override
  void initState() {
    // initializing the dialogflowtter
    DialogFlowtter.fromFile().then((instance) => _dialogFlowtter = instance);
    // ager file name dialog_flow_auth ki bjaye kuch aur ho tou fromAssets se access hoga
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MessagesScreen(messages: messages),
          ),
          Container(
            color: Colors.deepPurple,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 14,
              ),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_controller.text);
                    _controller.clear();
                  },
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        // print("men msg apka add krne lga hun vroo");
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      // print("abhi tk code chal rha hai");
      DetectIntentResponse response = await _dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));

      // print(response.message.toString() + "Yeh response msg hai");

      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  // Send Message
  // void sendMessage(String text) async {
  //   if (text.isEmpty) {
  //     debugPrint("kuch nhi likha vrooo tumne");
  //     return;
  //   } else {
  //     // first setState for user
  //     setState(() {
  //       addMessage(Message(text: DialogText(text: [text])), true);
  //     });

  //     DetectIntentResponse response = await _dialogFlowtter.detectIntent(
  //       queryInput: QueryInput(text: TextInput(text: text)),
  //     );

  //     if (response.message == null) {
  //       debugPrint("RESPONSE HI NULL HAI BHAI - ISLIAY WAPIS CHALA GYA");
  //       return;
  //     }
  //     setState(() {
  //       // second setState for bot (after getting the response against the message)
  //       addMessage(response.message!);
  //     });
  //   }
  // }

  void addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _dialogFlowtter.dispose();
    super.dispose();
  }
}
