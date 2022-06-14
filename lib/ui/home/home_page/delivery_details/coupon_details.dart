import 'dart:async';
import 'package:delivery/models/data_models/coupon.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/widgets/fade_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CouponDetails extends StatefulWidget {
  final StreamController<bool> controller;
  final Coupon coupon;

  CouponDetails({required this.controller, required this.coupon});

  @override
  _CouponDetailsState createState() => _CouponDetailsState();
}

class _CouponDetailsState extends State<CouponDetails>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      child: StreamBuilder<bool>(
        stream: widget.controller.stream,
        initialData: false,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(
                  Icons.local_offer,
                  color: themeModel.textColor,
                ),
                title: Text(
                  "Coupon",
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
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: FadeIn(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///Coupon code
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Code:',
                                  style: themeModel.theme.textTheme.bodyText2,
                                )),
                            Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  widget.coupon.code,
                                  style: themeModel.theme.textTheme.bodyText1!
                                      .apply(color: themeModel.secondTextColor),
                                )),

                            ///Coupon value
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Value:',
                                  style: themeModel.theme.textTheme.bodyText2,
                                )),
                            Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  widget.coupon.value.toString() +
                                      ((widget.coupon.type == 'percentage')
                                          ? "%"
                                          : "\$"),
                                  style: themeModel.theme.textTheme.bodyText1!
                                      .apply(color: themeModel.priceColor),
                                )),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
              Container(
                height: 0.5,
                color: themeModel.secondTextColor,
              ),
            ],
          );
        },
      ),
    );
  }
}
