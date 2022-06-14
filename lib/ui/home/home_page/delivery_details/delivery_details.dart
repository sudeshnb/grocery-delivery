import 'package:delivery/blocs/order_details_bloc.dart';
import 'package:delivery/models/data_models/history_item.dart';
import 'package:delivery/models/data_models/order.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/services/database.dart';
import 'package:delivery/ui/home/home_page/delivery_details/address_details.dart';
import 'package:delivery/ui/home/home_page/delivery_details/comments_details.dart';
import 'package:delivery/ui/home/home_page/delivery_details/coupon_details.dart';
import 'package:delivery/ui/home/home_page/delivery_details/items_details.dart';
import 'package:delivery/ui/home/home_page/delivery_details/payment_details.dart';
import 'package:delivery/ui/home/home_page/delivery_details/shipping_method_details.dart';
import 'package:delivery/ui/home/home_page/delivery_details/submit_delivery.dart';
import 'package:delivery/widgets/buttons/default_button.dart';
import 'package:delivery/widgets/fade_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DeliveryDetails extends StatefulWidget {
  final OrderDetailsBloc bloc;

  DeliveryDetails._({required this.bloc});

  static Future<HistoryItem?> create(BuildContext context, String path) {
    final database = Provider.of<Database>(context, listen: false);
    return Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => Provider<OrderDetailsBloc>(
                  create: (context) =>
                      OrderDetailsBloc(database: database, path: path),
                  child: Consumer<OrderDetailsBloc>(
                    builder: (context, bloc, _) {
                      return DeliveryDetails._(bloc: bloc);
                    },
                  ),
                )));
  }

  @override
  _DeliveryDetailsState createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  late Stream<Order> orderStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    orderStream = widget.bloc.getOrder();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: themeModel.theme.textTheme.headline3,
        ),
        backgroundColor: themeModel.secondBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: themeModel.textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<Order>(
        stream: orderStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Order order = snapshot.data!;

            return ListView(
              padding: EdgeInsets.all(0),
              children: [
                ///Number and date
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Order №${order.id}',
                        style: themeModel.theme.textTheme.headline3,
                      ),
                      Spacer(),
                      Text(
                        order.date,
                        style: themeModel.theme.textTheme.bodyText1!
                            .apply(color: themeModel.secondTextColor),
                      ),
                    ],
                  ),
                ),

                ///Status
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
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
                            color: (order.status == 'Delivered')
                                ? Colors.green
                                : (order.status == 'Declined')
                                    ? Colors.red
                                    : Colors.orange),
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(
                          (order.status == 'Delivered')
                              ? Icons.done
                              : (order.status == 'Declined')
                                  ? Icons.clear
                                  : Icons.pending_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        order.status,
                        style: themeModel.theme.textTheme.headline3!.apply(
                            color: (order.status == 'Delivered')
                                ? Colors.green
                                : (order.status == 'Declined')
                                    ? Colors.red
                                    : Colors.orange),
                      ),
                    ],
                  ),
                ),

                ///Items
                ItemsDetails(
                  controller: widget.bloc.itemsController,
                  products: order.products,
                ),

                ///Payment Details
                PaymentDetails(
                  controller: widget.bloc.paymentController,
                  paymentMethod: order.paymentMethod,
                ),

                ///Address
                AddressDetails(
                  controller: widget.bloc.addressController,
                  address: order.address,
                ),

                ///Shipping Method
                ShippingMethodDetails(
                  controller: widget.bloc.shippingMethodController,
                  shippingMethod: order.shippingMethod,
                ),

                ///Coupon
                (order.coupon == null)
                    ? SizedBox()
                    : CouponDetails(
                        controller: widget.bloc.couponController,
                        coupon: order.coupon!),

                ///Comments
                CommentsDetails(
                  controller: widget.bloc.commentsController,
                  adminComment: order.adminComment,
                ),

                ///Total
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        'Total Amount:',
                        style: themeModel.theme.textTheme.headline3,
                      )),
                      Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              order.total.toString() + '\$',
                              style: themeModel.theme.textTheme.headline3!
                                  .apply(color: themeModel.priceColor),
                            )),
                      )
                    ],
                  ),
                ),

                /// Accept/In process/Decline buttons
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      DefaultButton(
                        color: Colors.red,
                        widget: Text(
                          "Decline",
                          style: themeModel.theme.textTheme.headline3!
                              .apply(color: Colors.white),
                        ),
                        onPressed: () {
                          SubmitDelivery.create(context,
                              path: order.path, declineAction: true);
                        },
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      ),
                      DefaultButton(
                        color: Colors.green,
                        widget: Text(
                          "Deliver",
                          style: themeModel.theme.textTheme.headline3!
                              .apply(color: Colors.white),
                        ),
                        onPressed: () {
                          SubmitDelivery.create(context, path: order.path);
                        },
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return FadeIn(
              duration: Duration(milliseconds: 300),
              child: Center(
                child: SvgPicture.asset(
                  'images/error.svg',
                  width: width * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
