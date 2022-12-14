import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 12.0, bottom: 12),
          child: Center(
            child: Text(
              "Settings",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SwitchListTile(
            title: Text('Dark Theme'),
            subtitle:
                Text('Optimize your battery life by using the dark theme.'),
            value: _isSwitched,
            onChanged: (value) {
              setState(() {
                _isSwitched = value;
              });
            }),
        Divider(),
        ListTile(
          onTap: () {},
          leading: Icon(Icons.language),
          title: Text('Change Language'),
          subtitle: Text(
              'For better experience you can switch to a Language of your choice.'),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider(),
        ListTile(
          onTap: () {},
          leading: Icon(Icons.logout_rounded),
          title: Text('Log Out'),
          subtitle: Text('johndue@gmail.com'),
          trailing: Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
