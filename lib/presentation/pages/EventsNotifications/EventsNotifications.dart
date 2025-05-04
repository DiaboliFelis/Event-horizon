import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_horizon/presentation/pages/information_about_the_event/information_about_the_event_data.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _selectedNotificationTime;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final time = await context.read<EventCubit>().getNotificationPreference();
    setState(() {
      _selectedNotificationTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8ECFF),
      appBar: AppBar(
        title: const Text('Настройки уведомлений'),
        backgroundColor: const Color(0xFFD8ECFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Время уведомлений:'),
            Row(
              children: [
                Radio<String>(
                  value: 'день',
                  groupValue: _selectedNotificationTime,
                  onChanged: (value) {
                    setState(() {
                      _selectedNotificationTime = value;
                    });
                    context
                        .read<EventCubit>()
                        .saveNotificationPreference(value!);
                  },
                ),
                const Text('За день'),
              ],
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'час',
                  groupValue: _selectedNotificationTime,
                  onChanged: (value) {
                    setState(() {
                      _selectedNotificationTime = value;
                    });
                    context
                        .read<EventCubit>()
                        .saveNotificationPreference(value!);
                  },
                ),
                const Text('За час'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
