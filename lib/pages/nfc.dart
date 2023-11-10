import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NFCScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyNFCCustomScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF282828), // Cor do fundo
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF171717), // Cor do cabeçalho
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white), // Cor do texto
          bodyText2: TextStyle(color: Colors.white), // Cor do texto
        ),
      ),
    );
  }
}

class MyNFCCustomScreen extends StatefulWidget  {
    @override
  _MyNFCCustomScreenState createState() => _MyNFCCustomScreenState();
}

class _MyNFCCustomScreenState extends State<MyNFCCustomScreen> {
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
          Ndef? ndef = Ndef.from(tag);
          if (ndef != null){
            NdefMessage message = await ndef.read();
            Fluttertoast.showToast(msg: '${message}');
          }else{
            Fluttertoast.showToast(msg: 'Não foi possível acessar o conteúdo do cartão.');
          }
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
              width: 150.0, // Ajuste o tamanho conforme necessário
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
