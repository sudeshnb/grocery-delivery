import 'package:delivery/blocs/deliveries_bloc.dart';
import 'package:delivery/models/data_models/order.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/ui/home/home_page/delivery_details/delivery_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderCard extends StatelessWidget {


  final Order order;
  final void Function(Order) removeOrderLocally;




  const OrderCard({
    required this.order,
    required this.removeOrderLocally});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final bloc = Provider.of<DeliveriesBloc>(context);

    return ListTile(
      title: Text(
          "Order N:" + order.id,
        style: themeModel.theme.textTheme.headline3,
      ),

      subtitle: Text(
        order.date,
      style: themeModel.theme.textTheme.bodyText1!.apply(
        color: themeModel.secondTextColor
      ),
    ),


      onTap: () {
        DeliveryDetails.create(context, order.path).then((value) async {
          if (value != null) {
            await bloc.changeStatus(context,value, order.path);
            removeOrderLocally(order);
          }
        });
      },
    );
  }
}
