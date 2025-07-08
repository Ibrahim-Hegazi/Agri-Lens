import 'dart:io';

import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  XFile? _capturedImage;
  XFile? _pickedGalleryImage;
  bool _isFlashOn = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras![0], ResolutionPreset.medium);
      await _controller!.initialize();
      setState(() {});
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    _isFlashOn = !_isFlashOn;
    await _controller!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
    setState(() {});
  }


  Future<void> _takePicture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      final image = await _controller!.takePicture();
      setState(() {
        _capturedImage = image;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _capturedImage = picked;
        _pickedGalleryImage = picked;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _capturedImage == null
                ? (_controller != null && _controller!.value.isInitialized
                ? CameraPreview(_controller!)
                : Center(child: CircularProgressIndicator(color: Colors.white70,)))
                : Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
          ),

          if (_capturedImage == null)
            Center(
              child: SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  children: [
                    // الزاوية العليا اليسرى
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CustomPaint(painter: CornerPainter()),
                      ),
                    ),
                    // الزاوية العليا اليمنى
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Transform.rotate(
                        angle: 1.5708, // 90 degrees in radians
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CustomPaint(painter: CornerPainter()),
                        ),
                      ),
                    ),
                    // الزاوية السفلى اليمنى
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Transform.rotate(
                        angle: 3.1416, // 180 degrees
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CustomPaint(painter: CornerPainter()),
                        ),
                      ),
                    ),
                    // الزاوية السفلى اليسرى
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Transform.rotate(
                        angle: -1.5708, // -90 degrees
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CustomPaint(painter: CornerPainter()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_capturedImage != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                color: Colors.black.withAlpha(150),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red, size: 36),
                      onPressed: () => setState(() => _capturedImage = null),
                    ),
                    SizedBox(width: 40,),
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green, size: 36),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Color(0xff9D9DA1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (_) => Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: SizedBox(
                                height: 200, // طول الـ Bottom Sheet
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Scanning...',
                                      style: TextStyle(color: Color(0xff585858), fontSize: 20),
                                    ),
                                    SizedBox(height: 32),
                                    Container(
                                      height: 16,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white24,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          color: ColorManager.greenColor,
                                          backgroundColor: Color(0xffD9D9D9),
                                          minHeight: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 32),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context); 
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorManager.greenColor,
                                      ),
                                      child: Text('Cancel', style: TextStyle(fontSize: 18,color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),
            )
          else
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                color: Colors.black.withAlpha(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _pickFromGallery,
                      child: _pickedGalleryImage != null
                          ? Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.file(
                          File(_pickedGalleryImage!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900]?.withAlpha(100),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        width: 58,
                        height: 58,
                        child: Icon(Icons.photo, color: Colors.white70),
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.grey[900]?.withAlpha(100),
                      onPressed: _takePicture,
                      child: Icon(Icons.camera_alt, color: Colors.white70),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[900]?.withAlpha(100),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      width: 58,
                      height: 58,
                      child: IconButton(
                        icon: Icon(
                          _isFlashOn
                              ? Icons.flash_on
                              : Icons.flash_off,
                          color: _isFlashOn
                          ? Colors.yellow
                          : Colors.white70,
                          size: 28,
                        ),
                        onPressed: _toggleFlash,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final radius = 20.0;
    final lineLength = 20.0;

    final path = Path();

    path.moveTo(40, 0);
    path.lineTo(lineLength, 0);
    path.arcToPoint(
      Offset(0, lineLength),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    path.lineTo(0, 40);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

