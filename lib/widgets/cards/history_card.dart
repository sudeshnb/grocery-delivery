import 'package:delivery/models/data_models/history_item.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/widgets/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HistoryCard extends StatelessWidget {
  final HistoryItem history;

  const HistoryCard({required this.history});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      decoration: BoxDecoration(
          color: themeModel.secondBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                blurRadius: 30,
                offset: Offset(0, 5),
                color: themeModel.shadowColor)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Order number
          Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Order #" + history.order,
                style: themeModel.theme.textTheme.headline3,
              )),

          ///History date
          Row(
            children: [
              Text(
                "Date: ",
                style: themeModel.theme.textTheme.headline3,
              ),
              Spacer(),
              Text(
                "${history.date}",
                style: themeModel.theme.textTheme.bodyText1!
                    .apply(color: themeModel.secondTextColor),
              ),
            ],
          ),

          ///Order status
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Status: ",
                  style: themeModel.theme.textTheme.headline3,
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (history.status == 'Delivered')
                          ? Colors.green
                          : Colors.red),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(
                    (history.status == 'Delivered') ? Icons.done : Icons.clear,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                Text(
                  history.status,
                  style: themeModel.theme.textTheme.headline3!.apply(
                      color: (history.status == 'Delivered')
                          ? Colors.green
                          : Colors.red),
                ),
              ],
            ),
          ),

          //History comment/reason
          Padding(
            padding: EdgeInsets.only(bottom: 5, top: 5),
            child: Text(
              history.status == "Delivered" ? "Comment:" : "Reason:",
              style: themeModel.theme.textTheme.headline3,
            ),
          ),

          Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                history.comment,
                style: themeModel.theme.textTheme.bodyText1!
                    .apply(color: themeModel.secondTextColor),
              )),

          //History Image
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
                "Image:",
              style: themeModel.theme.textTheme.headline3,
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(history.image),
                        ),
                      );
                    });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  width: isPortrait ? width * 0.5 : height * 0.5,
                  image: NetworkImage(history.image),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
