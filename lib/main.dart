// ---------------------------------------------------------------------------
// 4. ACTIVE LIVE ROOM PAGE (Full Screen Camera + Clean Profile Bottom Sheet)
// ---------------------------------------------------------------------------
class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  Timer? _liveTimer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _initLiveCamera();
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

  Future<void> _initLiveCamera() async {
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
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

  // 🌟 የፕሮፋይል መረጃ ከታች ወደ ላይ የሚከፈተው መስኮት (ያለምንም የግራ ጥቁር ጥላ)
  void _showProfileDetailsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161823),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // መሃል ላይ ያለችው ትልቅ የፕሮፋይል ክብ ፎቶ
              const CircleAvatar(
                radius: 42,
                backgroundColor: Colors.amber,
                child: Icon(Icons.person, size: 45, color: Colors.black),
              ),
              const SizedBox(height: 12),
              
              // ስም እና የኢትዮጵያ ባንዲራ
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Alpha Motivation",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 6),
                  Text("🇪🇹", style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 6),

              // ሊቭል እና የአይዲ ቁጥር
              const Text(
                "Wealth Level: 15 | Live Level: 22",
                style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              const Text(
                "ID: 26948111",
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
              const SizedBox(height: 20),

              // Fans & Fan Club አማራጭ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Fans Fan Club (0)", style: TextStyle(color: Colors.white, fontSize: 14)),
                  Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
                ],
              ),
              const Divider(color: Colors.white24, height: 24),

              // Gift Gallery አማራጭ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Gift Gallery (Lit 0/12)", style: TextStyle(color: Colors.white, fontSize: 14)),
                  Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Full Screen Camera Background (ምንም አይነት የግራ ጥቁር ዳራ የሌለው)
          Positioned.fill(
            child: _isCameraInitialized
                ? CameraPreview(_cameraController!)
                : const Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
          ),

          // 2. Top Header Bar (ፕሮፋይል ሳጥን ሲነካ የፕሮፋይል ፖፕ-አፕ ብቻ ይከፍታል)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  // Clean Profile Header Box
                  GestureDetector(
                    onTap: _showProfileDetailsModal, // 👈 ሲነካ የፕሮፋይል መረጃውን ከታች ያመጣል
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.amber,
                            child: Icon(Icons.person, size: 16, color: Colors.black),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Alpha Motivation",
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  
                  // Exit Button (❌)
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
