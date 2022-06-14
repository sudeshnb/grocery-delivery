import 'package:delivery/helpers/project_configuration.dart';
import 'package:delivery/models/state_models/sign_in_model.dart';
import 'package:delivery/models/state_models/theme_model.dart';
import 'package:delivery/services/auth.dart';
import 'package:delivery/services/database.dart';
import 'package:delivery/widgets/buttons/default_button.dart';
import 'package:delivery/widgets/fade_in.dart';
import 'package:delivery/widgets/text_fields/email_text_field.dart';
import 'package:delivery/widgets/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final SignInModel model;

  SignIn._({required this.model});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    return ChangeNotifierProvider<SignInModel>(
      create: (BuildContext context) =>
          SignInModel(auth: auth, database: database),
      child: Consumer<SignInModel>(
        builder: (context, model, _) {
          return SignIn._(
            model: model,
          );
        },
      ),
    );
  }

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      body: Center(
          child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return true;
        },
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(20),
          children: <Widget>[
            ///Logo
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: FadeInImage(
                image: AssetImage(ProjectConfiguration.logo),
                placeholder: MemoryImage(kTransparentImage),
                width: 100,
                height: 100,
              ),
            ),

            ///Email textField
            EmailTextField(
                textEditingController: emailController,
                isLoading: widget.model.isLoading,
                focusNode: emailFocus,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.emailAddress,
                labelText: "Email",
                iconData: Icons.email,
                onSubmitted: () {},
                error: !widget.model.validEmail),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              child: (!widget.model.validEmail)
                  ? FadeIn(
                      child: Text(
                          'Please enter a valid email',
                        style: themeModel.theme.textTheme.subtitle2!.apply(
                          color: Colors.red
                        ),
                      )

                    )
                  : SizedBox(),
            ),

            ///Password textField
            EmailTextField(
                textEditingController: passwordController,
                isLoading: widget.model.isLoading,
                focusNode: passwordFocus,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                obscureText: true,
                labelText: "Password",
                iconData: Icons.lock_outline,
                onSubmitted: () {
                  widget.model.submit(
                      context, emailController.text, passwordController.text);
                },
                error: !widget.model.validPassword),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              child: (!widget.model.validPassword)
                  ? FadeIn(
                      child: Text(
                        'Please enter a valid password : don\'t forget numbers, special characters(@, # ...), capital letters',
                        style: themeModel.theme.textTheme.subtitle2!.apply(
                            color: Colors.red
                        ),
                      )


                    )
                  : SizedBox(),
            ),

            ///Submit button <--> Loading
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              child: widget.model.isLoading
                  ? Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : DefaultButton(
                      color: themeModel.accentColor,
                      widget: Text(
                          !widget.model.isSignedIn
                              ? "Create Account"
                              : "Sign In",
                        style: themeModel.theme.textTheme.headline3!.apply(
                          color: Colors.white
                        ),
                      ),
                      onPressed: () {
                        //Sign In function
                        widget.model.submit(context, emailController.text,
                            passwordController.text);
                      },
                    ),
            ),

            ///Switch  Sign In <--> Create Account
            Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: !widget.model.isLoading
                        ? () {
                            //Switch to create account or signIn
                            widget.model.changeSignStatus();
                          }
                        : null,
                    child: Text(
                      !widget.model.isSignedIn
                          ? "Create Account"
                          : "Sign In",
                      style: themeModel.theme.textTheme.headline3,
                    )


                  )),
            ),
          ],
        ),
      )),
    );
  }
}
