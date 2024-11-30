import 'package:flutter/material.dart';
import 'package:pam_final_client/pages/app/app_chats.dart';
import 'package:pam_final_client/pages/app/app_profile.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var _currentIndex = 0;
  // var webSocket = WebSocket();

  // This method is called only once and is used to connect
  // to the WebSocket server and send the token to the server,
  // this method is called after the first frame is rendered
  // For more information, see https://stackoverflow.com/questions/51901002/is-there-a-way-to-load-async-data-on-initstate-method
  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _asyncInitState();
  //   });
  // }

  // _asyncInitState() async {
  //   webSocket = WebSocket();
  //   webSocket.connect();
  //   await webSocket.channel.ready;
  //   String token = await Client().getToken();
  //   webSocket.sendMessage("Bearer $token");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const AppChats(),
        const AppProfile(),
      ][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
