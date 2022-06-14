import 'dart:io';
import 'package:delivery/models/state_models/submit_delivery_model.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/services/auth.dart';
import 'package:delivery/services/database.dart';
import 'package:delivery/widgets/buttons/default_button.dart';
import 'package:delivery/widgets/fade_in.dart';
import 'package:delivery/widgets/text_fields/default_text_field.dart';
import 'package:delivery/widgets/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubmitDelivery extends StatefulWidget {
  final SubmitDeliveryModel model;
  final bool declineAction;

  SubmitDelivery._({required this.model, this.declineAction = false});

  static create(BuildContext context,
      {required String path, bool declineAction = false}) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: ChangeNotifierProvider<SubmitDeliveryModel>(
              create: (context) => SubmitDeliveryModel(
                  database: database, auth: auth, path: path),
              child: Consumer<SubmitDeliveryModel>(
                builder: (context, model, _) {
                  return SubmitDelivery._(
                    model: model,
                    declineAction: declineAction,
                  );
                },
              ),
            ),
          );
        });
  }

  @override
  _SubmitDeliveryState createState() => _SubmitDeliveryState();
}

class _SubmitDeliveryState extends State<SubmitDelivery>
    with TickerProviderStateMixin {
  TextEditingController commentController = TextEditingController();

  FocusNode commentFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final themeModel = Provider.of<ThemeModel>(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: themeModel.secondBackgroundColor),
      padding: EdgeInsets.all(20),
      child: Wrap(
        children: [
          Align(
              alignment: Alignment.center,
              child: Text(
                (widget.declineAction ? "Decline" : "Submit") + " Delivery",
                style: themeModel.theme.textTheme.headline3,
              )),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Center(
              child: GestureDetector(
                onTap: !widget.model.isLoading
                    ? () {
                        widget.model.chooseImage(context);
                      }
                    : () {},
                child: AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            width: 2,
                            color: (!widget.model.validImage)
                                ? Colors.red
                                : Colors.transparent)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: (!widget.model.networkImage)
                          ? FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              image: (widget.model.image ==
                                      'images/upload_image.png')
                                  ? AssetImage(widget.model.image)
                                  : FileImage(File(widget.model.image))
                                      as ImageProvider,
                              width: (isPortrait) ? width / 3 : height / 4,
                              fit: BoxFit.cover,
                            )
                          : FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              image: NetworkImage(widget.model.image),
                              width: (isPortrait) ? width / 3 : height / 5,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: (!widget.model.validImage)
                ? FadeIn(
                    child: Center(
                        child: Text(
                      'Please choose an image',
                      style: themeModel.theme.textTheme.subtitle2!
                          .apply(color: Colors.red),
                    )),
                  )
                : SizedBox(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: DefaultTextField(
                controller: commentController,
                focusNode: commentFocus,
                enabled: !widget.model.isLoading,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 2,
                maxLines: null,
                labelText: widget.declineAction ? 'Reason' : 'Comment',
                onSubmitted: (value) {},
                changeBackColor: true,
                isLoading: widget.model.isLoading,
                error: !widget.model.validComment),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: (!widget.model.validComment)
                ? FadeIn(
                    child: Text(
                    'Please enter a valid comment',
                    style: themeModel.theme.textTheme.subtitle2!
                        .apply(color: Colors.red),
                  ))
                : SizedBox(),
          ),
          Align(
            alignment: Alignment.center,
            child: (widget.model.isLoading)
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    child: DefaultButton(
                        //margin: EdgeInsets.all(0),
                        widget: Text(
                          widget.declineAction ? "Decline" : "Submit",
                          style: themeModel.theme.textTheme.headline3!
                              .apply(color: Colors.white),
                        ),
                        onPressed: () async {
                          await widget.model.submit(context,
                              commentController.text, widget.declineAction);
                        },
                        color: widget.declineAction
                            ? Colors.red
                            : themeModel.accentColor),
                  ),
          )
        ],
      ),
    );
  }
}
