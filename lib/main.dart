import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

List<CameraDescription> _cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    _cameras = await availableCameras();
  } catch (e) {
    debugPrint("Camera initialization error: $e");
  }
  runApp(const AuraLiveApp());
}

class AuraLiveApp extends StatelessWidget {
  const AuraLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura Live Stream',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1015),
      ),
      home: const HomeLiveDiscoveryPage(),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. HOME & DISCOVERY PAGE
// ---------------------------------------------------------------------------
class HomeLiveDiscoveryPage extends StatefulWidget {
  const HomeLiveDiscoveryPage({super.key});

  @override
  State<HomeLiveDiscoveryPage> createState() => _HomeLiveDiscoveryPageState();
}

class _HomeLiveDiscoveryPageState extends State<HomeLiveDiscoveryPage> {
  final List<String> categories = [
    "Chating", "Singing", "Dancing", "Make friends", 
    "Talent", "Gourmet", "Music", "Funny", "Stories", "Sport"
  ];
  int selectedCategoryIndex = 0;
  
  CameraController? _previewCameraController;
  bool _isCameraReady = false;
  int _selectedCameraIndex = 0;

  final TextEditingController _titleController = TextEditingController(text: "Welcome to my Live Stream! 🔥");

  @override
  void initState() {
    super.initState();
    _initPreviewCamera();
  }

  Future<void> _initPreviewCamera() async {
    await [Permission.camera, Permission.microphone].request();
    if (_cameras.isNotEmpty) {
      _previewCameraController = CameraController(
        _cameras[_selectedCameraIndex],
        ResolutionPreset.high,
        enableAudio: true,
      );
      await _previewCameraController!.initialize();
      if (mounted) setState(() => _isCameraReady = true);
    }
  }

  void _switchCamera() async {
    if (_cameras.length > 1) {
      _selectedCameraIndex = (_selectedCameraIndex == 0) ? 1 : 0;
      await _previewCameraController?.dispose();
      setState(() => _isCameraReady = false);
      _initPreviewCamera();
    }
  }

  @override
  void dispose() {
    _previewCameraController?.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _openBeautyModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161823),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const BeautySettingsSheet(),
    );
  }

  void _openOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161823),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AdvancedOptionsMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera Live Preview Background
          Positioned.fill(
            child: _isCameraReady && _previewCameraController != null
                ? CameraPreview(_previewCameraController!)
                : Container(color: Colors.black),
          ),

          // Foreground Controls
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Action Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 26),
                        onPressed: () {},
                      ),
                      Row(
                        children: const [
                          Icon(Icons.location_on, color: Colors.amber, size: 18),
                          SizedBox(width: 4),
                          Text("Ethiopia", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      // Camera Switch Button
                      IconButton(
                        icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 26),
                        onPressed: _switchCamera,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 🌟 Profile Image Selector & Live Title Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      // Profile/Cover Selector
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("የፕሮፋይል/ከቨር ፎቶ ከፋይል ይምረጡ")),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white, width: 2),
                                color: Colors.black45,
                                image: const DecorationImage(
                                  image: NetworkImage("https://via.placeholder.com/150"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 2,
                              bottom: 2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.pinkAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit, color: Colors.white, size: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Live Title Input
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _titleController,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                hintText: "የላይቭ ርዕስ ያግኙ...",
                                hintStyle: TextStyle(color: Colors.white54, fontSize: 13),
                                border: InputBorder.none,
                              ),
                            ),
                            Container(height: 1, color: Colors.white30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 🌟 Categories Horizontal Scroll
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedCategoryIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedCategoryIndex = index),
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.pinkAccent : Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? Colors.pinkAccent : Colors.white24),
                          ),
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(),

                // Bottom Control Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: Colors.black54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.face_retouching_natural, color: Colors.white, size: 28),
                        onPressed: _openBeautyModal,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveRoomPage()));
                        },
                        child: const Text("Go Live", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz, color: Colors.white, size: 28),
                        onPressed: _openOptionsMenu,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. BEAUTY SETTINGS SHEET
// ---------------------------------------------------------------------------
class BeautySettingsSheet extends StatefulWidget {
  const BeautySettingsSheet({super.key});

  @override
  State<BeautySettingsSheet> createState() => _BeautySettingsSheetState();
}

class _BeautySettingsSheetState extends State<BeautySettingsSheet> {
  int mainTab = 0;
  double sliderValue = 50.0;

  final List<String> beautySubItems = ["Original", "Smooth", "Tone", "Clearness", "Face", "Eyes", "Nose", "Chin", "Forehead", "Lip"];
  final List<String> stickerSubItems = ["Original", "Christmas", "Ski goggles", "Bunny Ears", "Love", "Rabbit Ears", "Bear patch", "Shark"];
  final List<String> filterSubItems = ["Original", "CT", "Warm yellow", "Journey", "American Film", "Japanese Megazine", "Kyoto", "Honey peach"];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Text("0", style: TextStyle(color: Colors.white70, fontSize: 12)),
              Expanded(
                child: Slider(
                  value: sliderValue,
                  min: 0,
                  max: 100,
                  activeColor: Colors.pinkAccent,
                  onChanged: (val) => setState(() => sliderValue = val),
                ),
              ),
              const Text("100", style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 8),
              Text("${sliderValue.toInt()}", style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(color: Colors.white24),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _getSubItemsForTab().map((item) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(15)),
                child: Text(item, style: const TextStyle(color: Colors.white, fontSize: 12)),
              )).toList(),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabButton("Preset", 0),
              _buildTabButton("Beauty", 1),
              _buildTabButton("Sticker", 2),
              _buildTabButton("Filters", 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool selected = mainTab == index;
    return GestureDetector(
      onTap: () => setState(() => mainTab = index),
      child: Text(title, style: TextStyle(color: selected ? Colors.pinkAccent : Colors.white70, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  List<String> _getSubItemsForTab() {
    if (mainTab == 0) return ["Save as preset"];
    if (mainTab == 1) return beautySubItems;
    if (mainTab == 2) return stickerSubItems;
    return filterSubItems;
  }
}

// ---------------------------------------------------------------------------
// 3. ADVANCED OPTIONS MENU
// ---------------------------------------------------------------------------
class AdvancedOptionsMenu extends StatelessWidget {
  const AdvancedOptionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Live Stream Settings", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          SwitchListTile(title: const Text("Allow audience to send Gifts?", style: TextStyle(color: Colors.white, fontSize: 13)), value: true, activeColor: Colors.pinkAccent, onChanged: (v) {}),
          SwitchListTile(title: const Text("Invisible Spectators", style: TextStyle(color: Colors.white, fontSize: 13)), value: false, activeColor: Colors.pinkAccent, onChanged: (v) {}),
          SwitchListTile(title: const Text("Allow Momi to speak?", style: TextStyle(color: Colors.white, fontSize: 13)), value: true, activeColor: Colors.pinkAccent, onChanged: (v) {}),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. ACTIVE LIVE ROOM PAGE
// ---------------------------------------------------------------------------
class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initLiveCamera();
  }

  Future<void> _initLiveCamera() async {
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
      await _cameraController!.initialize();
      if (mounted) setState(() => _isCameraInitialized = true);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _isCameraInitialized ? CameraPreview(_cameraController!) : const Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                    child: const Text("Alpha Motivation", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 26),
                    onPressed: () => Navigator.pop(context),
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
