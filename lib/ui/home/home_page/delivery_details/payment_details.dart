import 'dart:async';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/widgets/fade_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentDetails extends StatefulWidget {
  final StreamController<bool> controller;
  final String paymentMethod;
  final String? paymentReference;

  PaymentDetails(
      {required this.controller,
      required this.paymentMethod,
      this.paymentReference});

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return AnimatedSize(
        duration: Duration(milliseconds: 300),
        child: StreamBuilder<bool>(
          initialData: false,
          stream: widget.controller.stream,
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 0.5,
                  color: themeModel.secondTextColor,
                ),
                ListTile(
                  leading: Icon(
                    Icons.credit_card_sharp,
                    color: themeModel.textColor,
                  ),
                  title: Text(
                    "Payment",
                    style: themeModel.theme.textTheme.headline3,
                  ),
                  onTap: () {
                    widget.controller.add(!snapshot.data!);
                  },
                  contentPadding:
                      EdgeInsets.only(right: 20, bottom: 5, top: 5, left: 20),
                  trailing: Icon(
                    (!snapshot.data!)
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: themeModel.textColor,
                  ),
                ),
                (snapshot.data!)
                    ? Padding(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: FadeIn(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Payment type
                              Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Payment type:',
                                    style: themeModel.theme.textTheme.bodyText2,
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    widget.paymentMethod,
                                    style: themeModel.theme.textTheme.bodyText1!
                                        .apply(
                                            color: themeModel.secondTextColor),
                                  )),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            );
          },
        ));
  }
}
