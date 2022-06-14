import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/ui/home/home_page/deliveries.dart';
import 'package:delivery/ui/home/home_page/history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: themeModel.shadowColor,
          title: Text(
              'Home',
            style: themeModel.theme.textTheme.headline3,
          ),
          centerTitle: true,
          backgroundColor: themeModel.secondBackgroundColor,
          leading: Container(),
          actions: [],
          bottom: TabBar(
            tabs: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Text(
                    'Processing',
                  style: themeModel.theme.textTheme.bodyText2!.apply(
                    color: themeModel.secondTextColor
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Text(
                  'History',
                  style: themeModel.theme.textTheme.bodyText2!.apply(
                      color: themeModel.secondTextColor
                  ),
                )

              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ///Deliveries
            Deliveries.create(context),

            ///History
            History.create(context),
          ],
        ),
      ),
    );
  }
}
