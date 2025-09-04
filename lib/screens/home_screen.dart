import 'package:flutter/material.dart';
import 'package:pixel_pos/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Screens for navigation
  final List<Widget> _screens = const [
    Center(child: Text("🏠 Home", style: TextStyle(fontSize: 22))),
    Center(child: Text("📊 Dashboard", style: TextStyle(fontSize: 22))),
    Center(child: Text("⚙️ Settings", style: TextStyle(fontSize: 22))),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: AppTheme.surfaceColor,
            child: Column(
              children: [
                // User info
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    "Mahmoud", // TODO: Replace with logged user name
                    style: AppTheme.textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    "Admin / " + // TODO: Replace with logged user role
                        "Pixelerion POS", // TODO: Replace with company  name
                    style: AppTheme.textTheme.bodyMedium,
                  ),
                ),

                const Divider(color: Colors.white24, thickness: 1),

                // Navigation menu
                _buildNavItem(Icons.home, "Home", 0),
                _buildNavItem(Icons.dashboard, "Dashboard", 1),
                _buildNavItem(Icons.settings, "Settings", 2),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'assets/icons/icon_logo.png', //TODO: replace with db company image
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Logout button
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: Text(
                    "Logout",
                    style: AppTheme.textTheme.bodyLarge?.copyWith(
                      color: Colors.redAccent,
                    ),
                  ),
                  onTap: () {
                    // TODO: Add logout logic
                  },
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Container(
              color: AppTheme.backgroundColor,
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primaryColor : Colors.white70,
      ),
      title: Text(
        title,
        style: AppTheme.textTheme.bodyLarge?.copyWith(
          color: isSelected ? AppTheme.primaryColor : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
