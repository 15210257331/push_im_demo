import 'package:flutter/material.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key key}) : super(key: key);

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<ScanPage> {

  // ScanController controller = ScanController();

  String qrcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // custom wrap size
      height: 250,
      // child: ScanView(
      //   controller: controller,
      //   // custom scan area, if set to 1.0, will scan full area
      //   scanAreaScale: .7,
      //   scanLineColor: Colors.green.shade400,
      //   onCapture: (data) {
      //     print(data);
      //   },
      // ),
    );
  }
}
