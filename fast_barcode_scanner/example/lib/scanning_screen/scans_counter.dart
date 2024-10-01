import 'package:fast_barcode_scanner/fast_barcode_scanner.dart';
import 'package:flutter/material.dart';

import '../history_screen/history_screen.dart';
import '../scan_history.dart';

class ScansCounter extends StatefulWidget {
  const ScansCounter({super.key});

  @override
  State<ScansCounter> createState() => _ScansCounterState();
}

class _ScansCounterState extends State<ScansCounter> {
  @override
  void initState() {
    super.initState();
    history.addListener(onBarcodeListener);
  }

  @override
  void dispose() {
    history.removeListener(onBarcodeListener);
    super.dispose();
  }

  void onBarcodeListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final barcode = history.recent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Row(
        children: [
          TextButton(
              onPressed: () async {
                final cam = CameraController.shared;
                cam.pauseCamera();
                await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()));
                cam.resumeCamera();
              },
              child: const Text('History')),
          const SizedBox(
              height: 30,
              width: 10,
              child: VerticalDivider(
                color: Colors.black26,
                thickness: 1,
                width: 1,
              )),
          Expanded(
            child: barcode != null
                ? Text(
                    "${history.count(barcode)}x\n${barcode.type.name} - ${(barcode.valueType != null ? barcode.valueType!.name : "")}: ${barcode.value}")
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
