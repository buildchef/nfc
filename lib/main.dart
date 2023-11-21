import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

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
          Ndef? ndef = Ndef.from(tag);
          if (ndef != null) {
            NdefMessage message = await ndef.read();
            for (NdefRecord record in message.records) {
              List<int> payload = record.payload;
              String jsonString = String.fromCharCodes(payload);
              Map<String, dynamic> data = json.decode(jsonString);
              String cpf = data["cpf"];

              // Chama a função para fazer a chamada Axios
              bool success = await fazerChamadaAxios(cpf);

              // Navega para a tela de sucesso ou erro com base na resposta da requisição
              if (success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuccessScreen(cpf: cpf),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ErrorScreen(),
                  ),
                );
              }

              Fluttertoast.showToast(msg: 'Operação realizada com sucesso!');
            }
          } else {
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

  Future<bool> fazerChamadaAxios(String cpf) async {
    Dio dio = Dio();
    String apiUrl = 'https://urano-api.onrender.com/urano/api/ponto/registrar';

    try {
      Response response = await dio.post(apiUrl, data: {'identificadorUnico': cpf, 'status': 'dia uti'});
      if (response.statusCode == 200 && response.data != null &&
          (response.data is Map || response.data is List) &&
          (response.data as Map).isNotEmpty) {
        return true; // Sucesso
      } else {
        return false; // Erro
      }
    } catch (error) {
      return false; // Erro de requisição
    }
  }
}

class SuccessScreen extends StatelessWidget {
  final String cpf;

  SuccessScreen({required this.cpf});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
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
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50.0,
            ),
            SizedBox(height: 10.0),
            Text(
              'Ponto registrado com sucesso!',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'CPF: $cpf',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
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
            Icon(
              Icons.error,
              color: Colors.red,
              size: 50.0,
            ),
            SizedBox(height: 10.0),
            Text(
              'Algo deu errado... Tente novamente mais tarde.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
