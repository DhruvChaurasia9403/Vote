
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../logic/theme_notifier.dart';
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: theme.primaryColor.withOpacity(0.2),
                        child: Icon(Icons.rocket_launch,
                            size: 30, color: theme.primaryColor),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'IdeaShare',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Where great ideas take flight.',
                        style: TextStyle(
                          color: theme.textTheme.bodySmall?.color
                              ?.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
                _buildDrawerItem(
                  context,
                  icon: Icons.lightbulb_outline,
                  text: 'All Ideas',
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/listing'),
                ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.5),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline,
                  text: 'My Profile',
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.5),
                _buildDrawerItem(
                  context,
                  icon: Icons.leaderboard_outlined,
                  text: 'Leaderboard',
                  onTap: () => Navigator.pushNamed(context, '/leaderboard'),
                ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.5),
                _buildDrawerItem(
                  context,
                  icon: Icons.thumb_up_alt_outlined,
                  text: 'Upvoted Ideas',
                  onTap: () => Navigator.pushNamed(context, '/upvoted'),
                ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.5),
                _buildDrawerItem(
                  context,
                  icon: Icons.tag_outlined,
                  text: 'Tagged Ideas',
                  onTap: () => Navigator.pushNamed(context, '/tagged'),
                ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.5),
              ],
            ),
          ),
          const Divider(),
          Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child) {
              return ListTile(
                title: const Text('Dark Mode'),
                leading: Icon(
                  themeNotifier.isDarkMode
                      ? Icons.nightlight_round
                      : Icons.wb_sunny_rounded,
                  color: theme.colorScheme.secondary,
                ),
                trailing: Switch(
                  value: themeNotifier.isDarkMode,
                  onChanged: (value) {
                    themeNotifier.toggleTheme();
                  },
                  activeTrackColor: theme.primaryColor.withOpacity(0.5),
                  activeColor: theme.primaryColor,
                ),
              );
            },
          ).animate().fadeIn(delay: 600.ms),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
        required String text,
        required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}