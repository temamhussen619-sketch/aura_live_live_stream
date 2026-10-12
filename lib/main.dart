import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  // Live Timer
  Timer? _liveTimer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _startLiveTimer();
  }

  void _startLiveTimer() {
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _secondsElapsed++);
    });
  }

  String _formatDuration(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  Future<void> _initCamera() async {
    await [Permission.camera, Permission.microphone].request();
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.high);
      await _cameraController!.initialize();
      if (mounted) setState(() => _isCameraInitialized = true);
    }
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // 4. አራቱ ነጥብ ሲነካ የሚከፈተው የ Host, Basic & Features Tools Sheet
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
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.82,
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
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.82,
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
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.82,
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
                    _ToolItem(icon: Icons.auto_awesome_motion, label: "Collection", color: Colors.purpleAccent),
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
    // Camera toggle logic
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

  void _showProfileModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161823),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.amber,
              child: Icon(Icons.person, size: 40, color: Colors.black),
            ),
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
          // 1. Camera View Background
          Positioned.fill(
            child: _isCameraInitialized
                ? CameraPreview(_cameraController!)
                : const Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
          ),

          // 2. TOP HEADER BAR (ፕሮፋይል በግራ፣ ሰዓት ቆጣሪ፣ ተመልካቾች እና ❌ በቀኝ ጥግ)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  // Profile Info (በግራ ጥግ ላይ ያለች አጭር ሳጥን)
                  GestureDetector(
                    onTap: _showProfileModal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.amber,
                            child: Icon(Icons.person, size: 18, color: Colors.black),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "Alpha Motivation",
                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "❤ 0",
                                style: TextStyle(color: Colors.pinkAccent, fontSize: 10),
                              ),
                            ],
                          ),
                          const SizedBox(width: 6),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Timer (የቀጥታ ስርጭት ሰዓት)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.amber, size: 13),
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
                        Icon(Icons.remove_red_eye, color: Colors.white, size: 13),
                        SizedBox(width: 4),
                        Text("1.2k", style: TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ❌ EXIT BUTTON (በቀኝ በኩል መጨረሻ ጥግ ላይ)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 24),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF161823),
                          title: const Text("Live ውጣ", style: TextStyle(color: Colors.white)),
                          content: const Text("እርግጠኛ ኖት ላይቭ ማቋረጥ ይፈልጋሉ?", style: TextStyle(color: Colors.white70)),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text("አይ", style: TextStyle(color: Colors.white))),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text("አዎ", style: TextStyle(color: Colors.pinkAccent)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 3. BOTTOM CONTROL TOOLBAR (ከታች የተደረደሩት አዝራሮች እና መሃል ላይ አራት ነጥብ)
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Comment Button
                    _buildIconButton(Icons.chat_bubble_outline, Colors.white24, () {}),
                    
                    // Mic Button
                    _buildIconButton(Icons.mic, Colors.white24, () {}),

                    // 🌟 FOUR-DOT MENU BUTTON (መሃል ላይ የተቀመጠው አራት ነጥብ)
                    GestureDetector(
                      onTap: _openAllToolsGridMenu,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.pinkAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 26),
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

// Grid tool item class
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
