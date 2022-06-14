import 'package:delivery/models/state_models/settings_model.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/services/auth.dart';
import 'package:delivery/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  final SettingsModel model;

  const Settings._({required this.model});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final database = Provider.of<Database>(context);
    return ChangeNotifierProvider<SettingsModel>(
      create: (context) => SettingsModel(auth: auth, database: database),
      child: Consumer<SettingsModel>(builder: (context, model, _) {
        return Settings._(
          model: model,
        );
      }),
    );
  }

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        shadowColor: themeModel.shadowColor,
        title: Text(
          'Settings',
          style: themeModel.theme.textTheme.headline3,
        ),
        centerTitle: true,
        backgroundColor: themeModel.secondBackgroundColor,
        leading: Container(),
      ),
      body: ListView(
        children: [
          /// Dark <--> Light mode switch button
          Container(
            decoration: BoxDecoration(
                color: themeModel.secondBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),

            margin: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            //   padding: EdgeInsets.all(20),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              onTap: () {
                themeModel.updateTheme();
              },
              leading: Icon(
                Icons.star_border,
                color: themeModel.accentColor,
              ),
              title: Text(
                'Dark mode',
                style: themeModel.theme.textTheme.bodyText1,
              ),
              trailing: Switch(
                activeColor: themeModel.accentColor,
                value: themeModel.theme.brightness == Brightness.dark,
                onChanged: (value) {
                  themeModel.updateTheme();
                },
              ),
            ),
          ),

          ///Logout
          Container(
            decoration: BoxDecoration(
                color: themeModel.secondBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),

            margin: EdgeInsets.only(bottom: 40, left: 20, right: 20, top: 20),
            //   padding: EdgeInsets.all(20),
            child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                onTap: () {
                  widget.model.signOut();
                },
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                title: Text(
                  'Logout',
                  style: themeModel.theme.textTheme.bodyText1,
                )),
          ),
        ],
      ),
    );
  }

}
