import 'package:flutter/material.dart';

import '../scan_history.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    history.addListener(onBarcodeListener);
  }

  void onBarcodeListener() {
    setState(() {});
  }

  @override
  void dispose() {
    history.removeListener(onBarcodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            onPressed: () => history.clear(),
            icon: const Icon(Icons.clear),
          )
        ],
      ),
      body: ListView.separated(
        itemBuilder: (ctx, idx) {
          final scan = history.scans[history.scans.length - idx - 1];
          return ListTile(
            title: Text(scan.value),
            subtitle: Text(
                "${scan.type.name} - ${scan.valueType != null ? scan.valueType!.name : ""}"),
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemCount: history.scans.length,
      ),
    );
  }
}
