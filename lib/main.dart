import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
          Fluttertoast.showToast(msg: 'Cartão NFC reconhecido');
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Color(0xFF282828)),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight - 1,
                decoration: BoxDecoration(
                  color: Color(0xFF171717),
                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: screenWidth * 0.009,
                      offset: Offset(0, screenWidth * 0.009),
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.107,
              top: screenHeight * 0.603,
              child: SizedBox(
                width: screenWidth * 0.785,
                height: screenHeight * 0.04,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Aproxime seu ',
                        style: TextStyle(
                          color: Color(0xFFE6EFF6),
                          fontSize: screenWidth * 0.061,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w300,
                          height: screenHeight * 0.001,
                        ),
                      ),
                      TextSpan(
                        text: 'crachá',
                        style: TextStyle(
                          color: Color(0xFFE6EFF6),
                          fontSize: screenWidth * 0.061,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: screenHeight * 0.001,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.139,
              top: screenHeight * 0.226,
              child: Container(
                width: screenWidth * 0.753,
                height: screenWidth * 0.753,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/nfc.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.068,
              top: screenHeight * 0.024,
              child: Container(
                width: screenWidth * 0.073,
                height: screenWidth * 0.073,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Stack(
                  children: [],
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.583,
              top: screenHeight * 0.013,
              child: SizedBox(
                width: screenWidth * 0.448,
                child: Text(
                  'NFC',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.109,
                    fontFamily: 'NATS',
                    fontWeight: FontWeight.w400,
                    height: screenHeight * 0.001,
                  ),
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.174,
              top: screenHeight * 0.089,
              child: Container(width: screenWidth * 0.647, height: screenHeight * 0.079),
            ),
          ],
        ),
      ),
    );
  }
}
