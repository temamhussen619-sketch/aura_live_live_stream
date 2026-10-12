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
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.82, // 👈 እዚህ ጋር ተጨምሯል
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
                  childAspectRatio: 0.82, // 👈 እዚህ ጋር ተጨምሯል
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
                  childAspectRatio: 0.82, // 👈 እዚህ ጋር ተጨምሯል
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
