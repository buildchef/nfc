import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NFCScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF282828),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF171717),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class NFCScreen extends StatefulWidget {
  @override
  _NFCScreenState createState() => _NFCScreenState();
}

class _NFCScreenState extends State<NFCScreen> {
  final TextEditingController _textController = TextEditingController();
  final NfcManager nfcManager = NfcManager.instance;

  @override
  void initState() {
    super.initState();
    startNFCSession();
  }

  void startNFCSession() async {
    bool isAvailable = await nfcManager.isAvailable();
    if (isAvailable) {
      nfcManager.startSession(
        onDiscovered: (NfcTag tag) async {
          // Exibindo o diálogo ao reconhecer o cartão NFC
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Cartão NFC Reconhecido"),
                content: Text("Seu cartão NFC foi reconhecido com sucesso!"),
                actions: <Widget>[
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Fechar o diálogo
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    nfcManager.stopSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'NFC',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/nfc.png',
              width: 150.0,
              height: 150.0,
            ),
            SizedBox(height: 16.0),
            Text(
              'Aproxime seu Badge',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
