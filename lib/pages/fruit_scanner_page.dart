import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:project_shop/generated/default.dart';

class FruitScannerPage extends StatefulWidget {
  const FruitScannerPage({super.key});

  @override
  State<FruitScannerPage> createState() => _FruitScannerPageState();
}

class _FruitScannerPageState extends State<FruitScannerPage> {
  CameraController? _cameraController;
  bool _isModelLoaded = false;
  bool _isDetecting = false;
  List<dynamic>? _recognitions;
  String _detectedFruit = "";
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadModel();
    await _setupCamera();
  }

  Future<void> _loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/model/model.tflite",
        labels: "assets/model/labels.txt",
      );
      debugPrint("Model loaded: $res");
      setState(() {
        _isModelLoaded = true;
      });
    } catch (e) {
      debugPrint("Error loading model: $e");
    }
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (!mounted) return;

    setState(() {});

    _cameraController!.startImageStream((CameraImage image) {
      if (!_isDetecting && _isModelLoaded) {
        _isDetecting = true;
        _runModelOnFrame(image);
      }
    });
  }

  Future<void> _runModelOnFrame(CameraImage image) async {
    try {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) => plane.bytes).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.4,
        asynch: true,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        setState(() {
          _recognitions = recognitions;
          _detectedFruit = recognitions[0]["label"];
          _confidence = recognitions[0]["confidence"];
        });
      } else {
        setState(() {
          _detectedFruit = "";
          _confidence = 0.0;
        });
      }
    } catch (e) {
      debugPrint("Error running model: $e");
    } finally {
      _isDetecting = false;
    }
  }

  Future<void> _selectFruit() async {
    if (_detectedFruit.isEmpty) return;

    try {
      final String name = _detectedFruit;
      // Use a consistent ID based on the name so it doesn't re-add every time
      final String id = "FRUIT_${name.toUpperCase().replaceAll(' ', '_')}";
      final double price = (Random().nextDouble() * 5 + 1); // Price between 1 and 6

      Navigator.pop(context, {
        'id': id,
        'name': name,
        'price': price,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting fruit: $e')),
      );
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
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Fruit Detector")),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          _buildResultOverlay(),
        ],
      ),
      floatingActionButton: _detectedFruit.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _selectFruit,
              label: Text("Select $_detectedFruit"),
              icon: const Icon(Icons.check),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildResultOverlay() {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _detectedFruit.isNotEmpty
                ? "$_detectedFruit (${(_confidence * 100).toStringAsFixed(0)}%)"
                : "Scanning for fruits...",
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
