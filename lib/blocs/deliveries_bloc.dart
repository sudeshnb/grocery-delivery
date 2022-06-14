import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/helpers/project_configuration.dart';
import 'package:delivery/models/data_models/history_item.dart';
import 'package:delivery/models/data_models/order.dart';
import 'package:delivery/services/auth.dart';
import 'package:delivery/services/cloud_functions.dart';
import 'package:delivery/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class DeliveriesBloc {
  final AuthBase auth;
  final Database database;

  DeliveriesBloc({required this.auth, required this.database});

  // ignore: close_sinks
  StreamController<List<Order>> ordersController = BehaviorSubject();

  Stream<List<Order>> get ordersStream => ordersController.stream;

  bool _canLoadMore = true;

  List<DocumentSnapshot> _lastDocuments = [];

  List<Order> savedOrders = [];

  Future<void> loadOrders(int length) async {
    if (_canLoadMore) {
      _canLoadMore = false;

      List<Order> newProducts = (await _getOrders(length))
          .map((e) => Order.fromMap(
              e.data() as Map<String, dynamic>, e.id, e.reference.path))
          .toList();

      savedOrders.addAll(newProducts);

      ordersController.add(savedOrders.toSet().toList());

      if (newProducts.length < length) {
        _canLoadMore = false;
      } else {
        _canLoadMore = true;
      }
    }
  }

  void removeOrderLocally(Order order) {
    savedOrders.remove(order);
    ordersController.add(savedOrders);
  }


  Future<void> refresh(int length) async{
    _canLoadMore = true;
    _lastDocuments = [];
    savedOrders = [];
    await loadOrders(length);
  }

  Future<List<DocumentSnapshot>> _getOrders(int length) async {
    final collection = await (database.getFutureCollectionGroupWithRange(
        'orders',
        startAfter: _lastDocuments.isEmpty ? null : _lastDocuments.last,
        length: length,
        orderBy: 'date',
        email: auth.email));

    if (collection.docs.isNotEmpty) {
      _lastDocuments.add(collection.docs.last);
    }

    return collection.docs;
  }

  ///This function is called to confirm order
  Future<void> changeStatus(BuildContext context,HistoryItem history, String path) async {
    ///Change order status
    await database.updateData({"status": history.status}, path);

    ///Add history
    await database.setData({
      "order": history.order,
      "status": history.status,
      "date": history.date,
      "image": history.image,
      "comment": history.comment,
    }, "delivery_boys/${auth.email}/history/${path.split("/").last}");

    ///Send Notification to admin and user
    await _sendNotifications(context,"Order status change!",
        "Order nº${path.split("/").last} is ${history.status}", path);
  }

  Future<void> _sendNotifications(BuildContext context,
      String title, String content, String orderPath) async {


    ///Send notification to user
    String userId = orderPath.split('/')[1];




      try {

        if(ProjectConfiguration.useCloudFunctions){
          final body = {
            "target_uid":userId,
            "title":title,
            "message":content,
          };
          final cloudFunctions=Provider.of<CloudFunctions>(context,listen: false);


          await cloudFunctions.sendNotification(body);


        }else{

          String? userToken = await _getUserToken(userId);

          if(userToken!=null){


            final body = {
              "token":userToken,
              "title":title,
              "message":content,
            };

            await http.post(Uri.parse(ProjectConfiguration.notificationsApi),
                body:json.encode(body)
            );

          }




        }

      } catch (e) {
        print(e);
      }

  }


  ///Get user token
  Future<String?> _getUserToken(String userId) async {
    print("User Id: " + userId);
    try {
      final snapshot =
      await database.getFutureDataFromDocument("users/$userId");

      Map? data = snapshot.data() as Map?;
      if (data != null) {
        return data['token'];
      } else {
        return null;
      }
    } catch (e) {
      print(e);

      return null;
    }
  }

}
