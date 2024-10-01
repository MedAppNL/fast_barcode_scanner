import 'package:fast_barcode_scanner/fast_barcode_scanner.dart';
import 'package:fast_barcode_scanner_example/configure_screen/overlay_selector.dart';
import 'package:fast_barcode_scanner_example/scanning_screen/scanning_overlay_config.dart';
import 'package:flutter/material.dart';

import 'type_selector.dart';

typedef OnOverlayConfigurationChanged = void Function(
    ScanningOverlayConfig overlayConfig);

class ConfigureScreen extends StatefulWidget {
  const ConfigureScreen(this._currentConfiguration, this._overlayConfig,
      {super.key, this.onOverlayConfigurationChanged});

  final ScannerConfiguration _currentConfiguration;
  final ScanningOverlayConfig _overlayConfig;
  final OnOverlayConfigurationChanged? onOverlayConfigurationChanged;

  @override
  State<ConfigureScreen> createState() => _ConfigureScreenState();
}

class _ConfigureScreenState extends State<ConfigureScreen> {
  late ScannerConfiguration _config;
  late ScanningOverlayConfig _overlayConfig;

  @override
  void initState() {
    _config = widget._currentConfiguration;
    _overlayConfig = widget._overlayConfig;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
        leading: BackButton(
          onPressed: () async {
            final shouldReturn = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Apply Changes?'),
                content: const Text('Return without applying changes?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Ok'),
                  ),
                ],
              ),
            );

            if (shouldReturn && context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: applyChanges,
            child: const Text(
              'Apply',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: const Text('Active code types'),
              subtitle: Text(_config.types.map((e) => e.name).join(', ')),
              onTap: () async {
                final types = await Navigator.push<List<BarcodeType>>(context,
                    MaterialPageRoute(builder: (_) {
                  return BarcodeTypeSelector(_config);
                }));
                setState(() {
                  _config = _config.copyWith(types: types);
                });
              },
            ),
            ListTile(
              title: const Text('Resolution'),
              trailing: DropdownButton<Resolution>(
                  value: _config.resolution,
                  onChanged: (value) {
                    setState(() {
                      _config = _config.copyWith(resolution: value);
                    });
                  },
                  items: buildDropdownItems(Resolution.values)),
            ),
            ListTile(
              title: const Text('Framerate'),
              trailing: DropdownButton<Framerate>(
                  value: _config.framerate,
                  onChanged: (value) {
                    setState(() {
                      _config = _config.copyWith(framerate: value);
                    });
                  },
                  items: buildDropdownItems(Framerate.values)),
            ),
            ListTile(
              title: const Text('Position'),
              trailing: DropdownButton<CameraPosition>(
                  value: _config.position,
                  onChanged: (value) {
                    setState(() => _config = _config.copyWith(position: value));
                  },
                  items: buildDropdownItems(CameraPosition.values)),
            ),
            ListTile(
              title: const Text('Detection Mode'),
              trailing: DropdownButton<DetectionMode>(
                value: _config.detectionMode,
                onChanged: (value) {
                  setState(
                    () => _config = _config.copyWith(detectionMode: value),
                  );
                },
                items: buildDropdownItems(DetectionMode.values),
              ),
            ),
            ListTile(
              title: const Text('Overlay'),
              subtitle: Text(
                  _overlayConfig.enabledOverlays.map((e) => e.name).join(', ')),
              onTap: () async {
                final overlayRoute = MaterialPageRoute(
                  builder: (_) => OverlaySelector(_overlayConfig),
                );

                final overlays = await Navigator.push(context, overlayRoute);

                setState(() {
                  _overlayConfig = _overlayConfig.copyWith(
                    enabledOverlays: overlays,
                  );
                });
              },
            ),
          ],
        ).toList(),
      ),
    );
  }

  List<DropdownMenuItem<E>> buildDropdownItems<E extends Enum>(
          List<E> enumCases) =>
      enumCases
          .map((v) => DropdownMenuItem(value: v, child: Text(v.name)))
          .toList();

  Future<void> applyChanges() async {
    try {
      await CameraController.shared.configure(
        types: _config.types,
        framerate: _config.framerate,
        resolution: _config.resolution,
        detectionMode: _config.detectionMode,
        position: _config.position,
      );
    } catch (error) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Fehler'),
          content: Text(error.toString()),
        ),
      );

      return;
    } finally {
      if (mounted) {
        Navigator.pop(context, _config);
      }
    }
  }
}
