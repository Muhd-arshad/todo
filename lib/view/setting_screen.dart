import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/controller/settings_controller.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<SettingsController>(context, listen: false).fetchUser();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ),
      body: Consumer<SettingsController>(
          builder: (context, settingsController, _) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${settingsController.userModel?.name ?? "No Name Available"}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),

              // Display user email
              Text(
                'Email: ${settingsController.userModel?.email ?? "No Email Available"}',
                style: const TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => settingsController.logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
