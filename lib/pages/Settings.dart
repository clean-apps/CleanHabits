import 'package:CleanHabits/data/WorkManagerService.dart';
import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:CleanHabits/widgets/basic/BottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  final ValueChanged<bool> themeChanged;
  Settings({this.themeChanged});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final sp = ProviderFactory.settingsProvider;
  final wms = WorkManagerService();

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var _accent = _theme.accentColor;
    var _darkMode = _theme.brightness == Brightness.dark;
    var _selectedNavIndex = 2;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text('Settings',
            style: TextStyle(color: _darkMode ? Colors.white : Colors.black)),
        backgroundColor: _theme.scaffoldBackgroundColor,
      ),
      body: SettingsList(
        lightBackgroundColor: _theme.scaffoldBackgroundColor,
        darkBackgroundColor: _theme.scaffoldBackgroundColor,
        sections: [
          SettingsSection(
            title: "Common",
            tiles: [
              SettingsTile(
                title: 'All Habits',
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(
                  context,
                  "/habit/all",
                ),
              ),
              SettingsTile(
                title: 'Time Of Day',
                leading: Icon(Icons.folder),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(
                  context,
                  "/settings/time-of-day",
                ),
              ),
              SettingsTile(
                title: "Start Week With",
                subtitle: sp.firstDayOfWeek == 'Mon' ? "Monday" : "Sunday",
                leading: Icon(Icons.calendar_today),
                switchActiveColor: _accent,
                onTap: () => showDialog(
                  context: context,
                  child: SimpleDialog(
                    title: Text('Start Week With'),
                    children: [
                      SimpleDialogOption(
                        child: CheckboxListTile(
                          title: Text('Sunday'),
                          value: sp.firstDayOfWeek == "Sun",
                          activeColor: _accent,
                          onChanged: (val) => setState(() {
                            sp.firstDayOfWeek = val ? "Sun" : "Mon";
                            Navigator.pop(context);
                          }),
                        ),
                      ),
                      SimpleDialogOption(
                        child: CheckboxListTile(
                          title: Text('Monday'),
                          value: sp.firstDayOfWeek == "Mon",
                          activeColor: _accent,
                          onChanged: (val) => setState(() {
                            sp.firstDayOfWeek = val ? "Mon" : "Sun";
                            Navigator.pop(context);
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SettingsTile.switchTile(
                title: "Dark Mode",
                leading: Icon(Icons.lightbulb_outline),
                switchValue: sp.darkMode,
                switchActiveColor: _accent,
                onToggle: (val) => {
                  setState(() {
                    sp.darkMode = val;
                  }),
                  widget.themeChanged(true),
                },
              )
            ],
          ),
          SettingsSection(
            title: "Notifications",
            tiles: [
              SettingsTile.switchTile(
                title: "Habit Reminders",
                leading: Icon(Icons.notifications),
                switchValue: sp.allowNotifcations,
                switchActiveColor: _accent,
                onToggle: (val) => setState(() {
                  sp.allowNotifcations = val;
                  sp.morningBriefing = val;
                  sp.weeklyReports = val;

                  if (val)
                    wms.activate();
                  else
                    wms.deactivate();
                }),
              ),
              SettingsTile.switchTile(
                title: "Daily Briefing",
                leading: Icon(Icons.dashboard),
                switchValue: sp.morningBriefing,
                switchActiveColor: _accent,
                onToggle: (val) => setState(() {
                  sp.morningBriefing = val;
                }),
              ),
              SettingsTile.switchTile(
                title: "Weekly Reports",
                leading: Icon(Icons.weekend),
                switchValue: sp.weeklyReports,
                switchActiveColor: _accent,
                onToggle: (val) => setState(() {
                  sp.weeklyReports = val;
                }),
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(index: _selectedNavIndex),
    );
  }
}
