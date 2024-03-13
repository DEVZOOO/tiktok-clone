import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/activity_screen.dart';

/// inbox
class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  void _onDmPressed() {
    // TODO - navigation
  }

  /// activity
  void _onActivityTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ActivityScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _onDmPressed,
            icon: const FaIcon(
              FontAwesomeIcons.paperPlane,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // activity
          ListTile(
            title: const Text(
              'Activity',
              style: TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: Sizes.size14,
              color: Colors.black,
            ), // suffix icon

            onTap: () => _onActivityTap(context),
          ),

          // divider
          Container(
            height: Sizes.size1,
            color: Colors.grey.shade200,
          ),

          // followers
          ListTile(
            leading: Container(
              // prefix icon
              width: Sizes.size52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.users,
                  color: Colors.white,
                ),
              ),
            ),
            title: const Text(
              'New followers',
              style: TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              'Messages from follwers will appear here',
              style: TextStyle(fontSize: Sizes.size14),
            ),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: Sizes.size14,
              color: Colors.black,
            ), // suffix icon
          ),
        ],
      ),
    );
  }
}
