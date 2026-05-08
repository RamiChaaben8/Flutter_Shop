import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:project_shop/generated/default.dart';

/// Mode for the fruit scanner:
/// - [addToDatabase]: Scan → ask for name + price/kg → save to Fruit table (Home page)
/// - [addToFacture]: Scan → look up from Fruit table → return data (Facture page)
enum FruitScannerMode { addToDatabase, addToFacture }

class FruitScannerPage extends StatefulWidget {
  final FruitScannerMode mode;
  const FruitScannerPage({super.key, required this.mode});

  @override
  State<FruitScannerPage> createState() => _FruitScannerPageState();
}

class _FruitScannerPageState extends State<FruitScannerPage> {
  final DefaultConnector _connector = DefaultConnector.instance;
  CameraController? _cameraController;
  bool _isModelLoaded = false;
  bool _isDetecting = false;
  bool _isBusy = false;
  bool _isInitializing = true;
  String? _initError;
  String _detectedFruit = '';
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _loadModel();
      await _setupCamera();
    } catch (e) {
      debugPrint('Initialization error: $e');
      if (mounted) {
        setState(() {
          _initError = e.toString();
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _loadModel() async {
    // NOTE: Do NOT call Tflite.close() here — it can crash if no model
    // is currently loaded (e.g. on first launch).
    String? res = await Tflite.loadModel(
      model: 'assets/model/model.tflite',
      labels: 'assets/model/labels.txt',
    );
    debugPrint('Model loaded: $res');
    if (mounted) setState(() => _isModelLoaded = true);
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) throw Exception('No cameras found on this device.');

    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() => _isInitializing = false);

    _cameraController!.startImageStream((CameraImage image) {
      if (!_isDetecting && _isModelLoaded && !_isBusy) {
        _isDetecting = true;
        _runModelOnFrame(image);
      }
    });
  }

  Future<void> _runModelOnFrame(CameraImage image) async {
    try {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((p) => p.bytes).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.4,
        asynch: true,
      );

      if (mounted && recognitions != null && recognitions.isNotEmpty) {
        setState(() {
          _detectedFruit = recognitions[0]['label'];
          _confidence = recognitions[0]['confidence'];
        });
      } else if (mounted) {
        setState(() {
          _detectedFruit = '';
          _confidence = 0.0;
        });
      }
    } catch (e) {
      debugPrint('Model inference error: $e');
    } finally {
      _isDetecting = false;
    }
  }

  /// Stop camera stream safely before any navigation or dialog
  Future<void> _stopCamera() async {
    try {
      if (_cameraController != null && _cameraController!.value.isStreamingImages) {
        await _cameraController!.stopImageStream();
      }
    } catch (e) {
      debugPrint('Error stopping camera stream: $e');
    }
  }

  Future<void> _onConfirm() async {
    if (_detectedFruit.isEmpty || _isBusy) return;
    setState(() => _isBusy = true);

    // Stop camera BEFORE any async work or navigation to prevent crash on reuse
    await _stopCamera();

    final String fruitId = _detectedFruit.toLowerCase().replaceAll(' ', '_');

    if (widget.mode == FruitScannerMode.addToDatabase) {
      await _handleAddToDatabase(fruitId);
    } else {
      await _handleAddToFacture(fruitId);
    }

    setState(() => _isBusy = false);
  }

  Future<void> _handleAddToDatabase(String fruitId) async {
    final nameController = TextEditingController(text: _detectedFruit);
    final priceController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Fruit to Database'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Fruit Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Price per kg (TND)',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(priceController.text);
              final name = nameController.text.trim();
              if (name.isEmpty || price == null || price <= 0) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid name and price.')),
                );
                return;
              }
              Navigator.pop(ctx, true);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final name = nameController.text.trim();
    final price = double.parse(priceController.text.trim());
    final id = name.toLowerCase().replaceAll(' ', '_');

    try {
      await _connector.upsertFruit(id: id, name: name, pricePerKg: price).execute();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name saved at ${price.toStringAsFixed(3)} TND/kg ✅')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving fruit: $e')),
        );
      }
    }
  }

  Future<void> _handleAddToFacture(String fruitId) async {
    try {
      final response = await _connector.getFruitById(id: fruitId).execute();
      final fruit = response.data.fruit;

      if (fruit == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '"$_detectedFruit" not found in database.\nAdd it first from the Home page.',
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      if (mounted) {
        Navigator.pop(context, {
          'id': fruit.id,
          'name': fruit.name,
          'pricePerKg': fruit.pricePerKg,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error looking up fruit: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAddMode = widget.mode == FruitScannerMode.addToDatabase;

    // Show error if initialization failed
    if (_initError != null) {
      return Scaffold(
        appBar: AppBar(title: Text(isAddMode ? 'Add Fruit to Database' : 'Scan Fruit for Facture')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Camera / Model Error',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _initError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Show loading spinner while initializing
    if (_isInitializing || _cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isAddMode ? 'Add Fruit to Database' : 'Scan Fruit for Facture'),
      ),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          _buildOverlay(isAddMode),
        ],
      ),
      floatingActionButton: _detectedFruit.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _isBusy ? null : _onConfirm,
              label: _isBusy
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(isAddMode ? 'Add "$_detectedFruit"' : 'Use "$_detectedFruit"'),
              icon: _isBusy ? null : Icon(isAddMode ? Icons.save : Icons.check),
              backgroundColor: isAddMode ? Colors.green : Colors.blue,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildOverlay(bool isAddMode) {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _detectedFruit.isNotEmpty
                  ? '$_detectedFruit (${(_confidence * 100).toStringAsFixed(0)}%)'
                  : 'Scanning for fruits...',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          if (_detectedFruit.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: (isAddMode ? Colors.green : Colors.blue).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isAddMode ? 'Tap to set name & price/kg' : 'Tap to fetch price from database',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
