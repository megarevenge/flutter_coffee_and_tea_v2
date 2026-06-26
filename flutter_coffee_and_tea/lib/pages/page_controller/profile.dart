import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coffee_and_tea/services/auth_service.dart';
import 'package:liquid_glass_widgets/widgets/shared/glass_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Grab the currently authenticated Firebase user instance
  final User? user = FirebaseAuth.instance.currentUser;

  // Log out method hooked up to your custom AuthService
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    await AuthService().signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Safely extract authentication strings or set fallbacks if parameters are null
    final String userEmail = user?.email ?? "No Email Registered";
    final String userPhone = user?.phoneNumber ?? "Not Added Yet";

    // Fallback display name extracted from the email string if missing from metadata profile
    final String userName = user?.displayName ?? userEmail.split('@')[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xffF3E4C9),
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff8A5F41),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: GlassPage(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // 1. DYNAMIC PROFILE AVATAR BLOCK
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: const Color(0xff8A5F41).withAlpha(30),
                        // If the user has a Google photoURL, display it; otherwise show a fallback Icon
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null,
                        child: user?.photoURL == null
                            ? const Icon(
                                Icons.person_rounded,
                                size: 70,
                                color: Color(0xff8A5F41),
                              )
                            : null,
                      ),
                      Container(
                        height: 36,
                        width: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xff8A5F41),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Greeting Header using Firebase name/email parsing
                Text(
                  'Welcome, $userName',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // 2. LIVE ACCOUNT INFORMATION FIELDS
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Account Information',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Real Dynamic Email Address from Firebase Auth
                _buildInfoTile(
                  icon: Icons.email_rounded,
                  title: 'Email Address',
                  value: userEmail,
                ),
                const SizedBox(height: 12),

                // Real Dynamic Phone Number from Firebase Auth
                _buildInfoTile(
                  icon: Icons.phone_rounded,
                  title: 'Phone Number',
                  value: userPhone,
                ),
                const SizedBox(height: 40),

                // 3. ACTIONS PANEL (Includes redundant Sign Out trigger)
                _buildMenuButton(
                  icon: Icons.history_rounded,
                  title: 'Past Orders History',
                  onTap: () {},
                ),
                _buildMenuButton(
                  icon: Icons.location_on_rounded,
                  title: 'Delivery Addresses',
                  onTap: () {},
                ),
                _buildMenuButton(
                  icon: Icons.logout_rounded,
                  title: 'Log Out',
                  isDestructive: true,
                  onTap:
                      signOut, // Connected cleanly to your state logging out process
                ),

                const SizedBox(
                  height: 100,
                ), // Protects screen layout spacing against bottom bar boundaries
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Component Builder for Information Blocks
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff8A5F41), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Component Builder for Interactive Actions
  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final textColor = isDestructive
        ? Colors.red.shade600
        : const Color(0xff8A5F41);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.grey.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade100),
        ),
        leading: Icon(icon, color: textColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red.shade600 : Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: isDestructive
              ? Colors.red.withAlpha(100)
              : Colors.grey.shade400,
        ),
      ),
    );
  }
}
