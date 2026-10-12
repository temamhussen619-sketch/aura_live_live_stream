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
    debugPrint("Camera error: $e");
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
// 1. HOME & DISCOVERY PAGE (Categories & Main Go Live)
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.close, color: Colors.white, size: 24),
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text("Ethiopia", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Icon(Icons.cameraswitch_rounded, color: Colors.white, size: 24),
                ],
              ),
            ),
            
            // Categories Horizontal Scroll
            SizedBox(
              height: 45,
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
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.pinkAccent : Colors.white12,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Center Preview Banner
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.pinkAccent, Colors.amber],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.live_tv, size: 60, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Aura Live Stream", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text("የምትፈልጉትን ምድብ መርጠው ላይቭ መጀመር ይችላሉ!", style: TextStyle(color: Colors.white60, fontSize: 13)),
                  ],
                ),
              ),
            ),

            // Bottom Bar: Beauty, Go Live, Options (---)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Colors.black.withOpacity(0.5),
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
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
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
    );
  }
}

// ---------------------------------------------------------------------------
// 2. BEAUTY SETTINGS MODAL (Preset, Beauty, Sticker, Filters + Slider)
// ---------------------------------------------------------------------------
class BeautySettingsSheet extends StatefulWidget {
  const BeautySettingsSheet({super.key});

  @override
  State<BeautySettingsSheet> createState() => _BeautySettingsSheetState();
}

class _BeautySettingsSheetState extends State<BeautySettingsSheet> {
  int mainTab = 0; // 0: Preset, 1: Beauty, 2: Sticker, 3: Filters
  double sliderValue = 50.0;

  final List<String> beautySubItems = ["Original", "Smooth", "Tone", "Clearness", "Face", "Eyes", "Nose", "Chin", "Forehead", "Lip"];
  final List<String> stickerSubItems = ["Original", "Christmas", "Ski goggles", "Bunny Ears", "Love", "Rabbit Ears", "Bear patch", "Shark", "Elk antlers"];
  final List<String> filterSubItems = ["Original", "CT", "Warm yellow", "Journey", "American Film", "Japanese Megazine", "Kyoto", "Honey peach"];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Slider value adjuster
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

          // Sub-items based on main tab
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _getSubItemsForTab().map((item) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(15)),
                child: Text(item, style: const TextStyle(color: Colors.white, fontSize: 12)),
              )).toList(),
            ),
          ),
          const Spacer(),

          // 4 Main Tabs: Preset, Beauty, Sticker, Filters
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
      child: Text(title, style: TextStyle(color: selected ? Colors.pinkAccent : Colors.white70, fontWeight: FontWeight.bold, fontSize: 15)),
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
// 3. ADVANCED SETTINGS MENU (3 Dots Options)
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
          _buildToggleOption("Allow audience to send Gifts?", true),
          _buildToggleOption("Invisible Spectators", false),
          _buildToggleOption("Allow Momi to speak?", true),
          ListTile(
            title: const Text("Key room", style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(context: context, builder: (context) => const KeyRoomSheet());
            },
          ),
          ListTile(
            title: const Text("Live Stream quality", style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(context: context, builder: (context) => const StreamQualitySheet());
            },
          ),
          ListTile(
            title: const Text("Live Stream Introduction", style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(context: context, builder: (context) => const StreamIntroSheet());
            },
          ),
          ListTile(
            title: const Text("Speech Setting", style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(context: context, builder: (context) => const SpeechSettingSheet());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String title, bool val) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      value: val,
      activeColor: Colors.pinkAccent,
      onChanged: (v) {},
    );
  }
}

// Sub-sheets for Key Room, Quality, Intro, Speech
class KeyRoomSheet extends StatelessWidget {
  const KeyRoomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
              const Text("Key Room Information", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const Icon(Icons.help_outline, color: Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          const Text("Only those who are invited or have a key can watch", style: TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 20),
          TextField(decoration: InputDecoration(hintText: "Enter Room Key", filled: true, fillColor: Colors.white12, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Copy link and key", style: TextStyle(color: Colors.white)),
              Icon(Icons.copy, color: Colors.pinkAccent),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, minimumSize: const Size(double.infinity, 45)),
            onPressed: () {},
            child: const Text("Go Live in Key room", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

class StreamQualitySheet extends StatelessWidget {
  const StreamQualitySheet({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
              const Expanded(child: Text("Live Stream Quality", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ],
          ),
          const ListTile(title: Text("Ultra High Definition", style: TextStyle(color: Colors.white)), trailing: Icon(Icons.check, color: Colors.pinkAccent)),
          const ListTile(title: Text("High Definition", style: TextStyle(color: Colors.white))),
          const ListTile(title: Text("Standard Definition", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}

class StreamIntroSheet extends StatelessWidget {
  const StreamIntroSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
              const Expanded(child: Text("Live Stream Introduction", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ],
          ),
          SwitchListTile(title: const Text("Enable Live Stream Introduction", style: TextStyle(color: Colors.white)), value: true, onChanged: (v) {}),
          const SizedBox(height: 10),
          TextField(maxLines: 4, decoration: InputDecoration(hintText: "Write content here...", filled: true, fillColor: Colors.white12, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, minimumSize: const Size(double.infinity, 45)),
            onPressed: () {},
            child: const Text("Create now", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

class SpeechSettingSheet extends StatelessWidget {
  const SpeechSettingSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
              const Expanded(child: Text("Speech Setting", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ],
          ),
          const ListTile(title: Text("Block List / Blocked Words", style: TextStyle(color: Colors.white)), trailing: Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. LIVE STREAM ROOM PAGE (Active Stream, Profile details, Popup cards)
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
    _initCamera();
  }

  Future<void> _initCamera() async {
    await [Permission.camera, Permission.microphone].request();
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
      await _cameraController!.initialize();
      if (mounted) setState(() => _isCameraInitialized = true);
    }
  }

  void _showProfileModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161823),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Colors.amber, child: Icon(Icons.person, size: 40, color: Colors.black)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Alpha Motivation", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text("🇪🇹", style: TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 5),
            const Text("Wealth Level: 15 | Live Level: 22", style: TextStyle(color: Colors.amber, fontSize: 12)),
            const Text("ID: 26948111", style: TextStyle(color: Colors.white60, fontSize: 12)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Fans Fan Club (0)", style: TextStyle(color: Colors.white)),
                Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
              ],
            ),
            const Divider(color: Colors.white24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Gift Gallery (Lit 0/12)", style: TextStyle(color: Colors.white)),
                Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _isCameraInitialized ? CameraPreview(_cameraController!) : const Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
          ),
          // Top Header Profile Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _showProfileModal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          const CircleAvatar(radius: 16, backgroundColor: Colors.amber, child: Icon(Icons.person, size: 18, color: Colors.black)),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Alpha Motivation", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              Text("❤ 0", style: TextStyle(color: Colors.pinkAccent, fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF161823),
                          title: const Text("Live ውጣ", style: TextStyle(color: Colors.white)),
                          content: const Text("እርግጠኛ ኖት ላይቭ ማቋረጥ ይፈልጋሉ?", style: TextStyle(color: Colors.white70)),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text("አይ", style: TextStyle(color: Colors.white))),
                            TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text("አዎ", style: TextStyle(color: Colors.pinkAccent))),
                          ],
                        ),
                      );
                    },
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
