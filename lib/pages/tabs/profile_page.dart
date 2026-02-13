import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 8,
        children: [
          CircleAvatar(
            minRadius: 80,
            child: Text(
              "P",
              style: Theme.of(
                context,
              ).textTheme.displayLarge!.copyWith(fontSize: 40),
            ),
          ),
          Text(
            "Prashant Suthar",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            'Username : prash-180206',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          ListTile(
            title: Text("Manage Profile"),
            leading: Icon(Icons.person),
            subtitle: Text("Edit/Update Profile"),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.chevron_right),
            ),
          ),

          ListTile(
            title: Text("Manage Notifications"),
            subtitle: Text("notifications"),
            leading: Icon(Icons.notifications),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.chevron_right),
            ),
          ),
          ListTile(
            title: Text("Theme"),
            subtitle: Text("Dark/light theme"),
            leading: Icon(Icons.sunny),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.chevron_right),
            ),
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.logout),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.chevron_right),
            ),
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.logout),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
