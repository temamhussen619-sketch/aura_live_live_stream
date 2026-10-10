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
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const LiveRoomPage(),
    );
  }
}

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  // Live Duration Timer Variables
  Timer? _liveTimer;
  int _secondsElapsed = 0;

  // Mock User / Coin Data
  int _myCoins = 1250;
  int _earnedPoints = 4820;

  @override
  void initState() {
    super.initState();
    _initializeCameraAndPermissions();
    _startLiveTimer();
  }

  void _startLiveTimer() {
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  String _formatDuration(int totalSeconds) {
    int durationMinutes = totalSeconds ~/ 60;
    int durationSeconds = totalSeconds % 60;
    String minutesStr = durationMinutes.toString().padLeft(2, '0');
    String secondsStr = durationSeconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  Future<void> _initializeCameraAndPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(
        _cameras[0],
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // ALL-TOOLS GRID MENU (ከታች አራት ነጥቡ ሲነካ የሚከፈተው ሜኑ)
  // ---------------------------------------------------------------------------
  void _openAllToolsGridMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161823).withOpacity(0.95),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          maxChildSize: 0.85,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16.0),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // SECTION 1: Host Tools
                _buildSectionHeader("Host Tools"),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  children: const [
                    _ToolItem(icon: Icons.admin_panel_settings, label: "Admins", color: Colors.blue),
                    _ToolItem(icon: Icons.chat_bubble, label: "Text Bubble", color: Colors.lightBlue),
                    _ToolItem(icon: Icons.favorite, label: "Fan Club", color: Colors.pinkAccent),
                    _ToolItem(icon: Icons.bar_chart, label: "Live Data", color: Colors.amber),
                    _ToolItem(icon: Icons.star, label: "Management", color: Colors.orange),
                    _ToolItem(icon: Icons.music_note, label: "Ambient Sound", color: Colors.purpleAccent),
                    _ToolItem(icon: Icons.videocam, label: "Recording", color: Colors.redAccent),
                    _ToolItem(icon: Icons.campaign, label: "Intro", color: Colors.teal),
                  ],
                ),
                const SizedBox(height: 24),

                // SECTION 2: Basic Tools
                _buildSectionHeader("Basic Tools"),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  children: [
                    const _ToolItem(icon: Icons.email, label: "Message", color: Colors.blueAccent),
                    _ToolItem(
                      icon: Icons.cameraswitch,
                      label: "Switch Cam",
                      color: Colors.green,
                      onTap: () {
                        Navigator.pop(context);
                        _toggleCamera();
                      },
                    ),
                    const _ToolItem(icon: Icons.face, label: "Beauty", color: Colors.purple),
                    const _ToolItem(icon: Icons.flip, label: "Mirror", color: Colors.indigo),
                    const _ToolItem(icon: Icons.share, label: "Share", color: Colors.lightGreen),
                    const _ToolItem(icon: Icons.tune, label: "Effect & Msg", color: Colors.deepOrange),
                    const _ToolItem(icon: Icons.graphic_eq, label: "Noise Reduct", color: Colors.cyan),
                  ],
                ),
                const SizedBox(height: 24),

                // SECTION 3: Features Center
                _buildSectionHeader("Features Center"),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  children: const [
                    _ToolItem(icon: Icons.emoji_events, label: "Rank", color: Colors.amber),
                    _ToolItem(icon: Icons.flash_on, label: "PK", color: Colors.orange),
                    _ToolItem(icon: Icons.monetization_on, label: "Rewards", color: Colors.yellow),
                    _ToolItem(icon: Icons.shopping_bag, label: "Store", color: Colors.red),
                    _ToolItem(icon: Icons.diamond, label: "VIP", color: Colors.deepPurple),
                    _ToolItem(icon: Icons.card_giftcard, label: "Gift Center", color: Colors.pink),
                    _ToolItem(icon: Icons.work, label: "Bag", color: Colors.blue),
                    _ToolItem(icon: Icons.collections, label: "Gift Gallery", color: Colors.cyan),
                    _ToolItem(icon: Icons.all_inclusive, label: "Lucky Box", color: Colors.orangeAccent),
                    _ToolItem(icon: Icons.auto_awesome_motion, label: "Collection", color: Colors.magenta),
                    _ToolItem(icon: Icons.auto_awesome, label: "Gift Wish", color: Colors.amberAccent),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      },
    );
  }

  void _toggleCamera() async {
    if (_cameras.length > 1) {
      final cameraIndex = _cameraController!.description.lensDirection == CameraLensDirection.front ? 0 : 1;
      _cameraController = CameraController(_cameras[cameraIndex], ResolutionPreset.high);
      await _cameraController!.initialize();
      setState(() {});
    }
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MAIN UI BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Camera Live Viewport
          Positioned.fill(
            child: _isCameraInitialized
                ? CameraPreview(_cameraController!)
                : const Center(child: CircularProgressIndicator(color: Colors.amber)),
          ),

          // 2. Top Header Bar (Host Profile, Timer, Viewers)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  // Profile Info
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.person, color: Colors.black, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text("Temam Live", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            Text("ID: 26948111", style: TextStyle(color: Colors.white70, fontSize: 10)),
                          ],
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.circular(10)),
                          child: const Text("+ Follow", style: TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Live Timer Display (ሰዓት ቆጣሪ)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          _formatDuration(_secondsElapsed),
                          style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Viewers Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: const [
                        Icon(Icons.remove_red_eye, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text("1.2k", style: TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Exit Button
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),

          // 3. Live Chat Overlay
          Positioned(
            left: 12,
            bottom: 80,
            right: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChatItem("Aura System", "እንኳን ወደ አውራ ላይቭ በደህና መጡ! 🚀", Colors.amber),
                const SizedBox(height: 6),
                _buildChatItem("Temam Tech", "ሰላም ለዚህ ሩም ይሁን! 👋", Colors.lightBlueAccent),
              ],
            ),
          ),

          // 4. Bottom Control Toolbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Comment Button
                    _buildIconButton(Icons.chat_bubble_outline, Colors.white24, () {}),
                    // Mic Button
                    _buildIconButton(Icons.mic, Colors.white24, () {}),
                    
                    // 🌟 FOUR-DOT MENU BUTTON (GRID MENU)
                    GestureDetector(
                      onTap: _openAllToolsGridMenu,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            const Icon(Icons.grid_view_rounded, color: Colors.white, size: 24),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // PK Button
                    _buildIconButton(Icons.sports_kabaddi, Colors.deepOrangeAccent, () {}),
                    // Gift Button
                    _buildIconButton(Icons.card_giftcard, Colors.pinkAccent, () {}),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(String user, String message, Color nameColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "$user: ", style: TextStyle(color: nameColor, fontWeight: FontWeight.bold, fontSize: 13)),
            TextSpan(text: message, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color bg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// GRID TOOL ITEM WIDGET
// ---------------------------------------------------------------------------
class _ToolItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ToolItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.5), width: 1),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
