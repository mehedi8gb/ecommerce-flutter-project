import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import '../../../chat/pages/chat_with_admin.dart';
import '../../../models/app_state_model.dart';
import '../../../ui/accounts/login/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountFloatingButton extends StatelessWidget {
  final model = AppStateModel();
  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    if(model.blocks.settings.chatType == 'whatsapp') {
      return FloatingActionButton(
        onPressed: () => _launch('https://wa.me/' + model.blocks.settings.whatsapp),
        tooltip: 'Chat',
        child: Icon(FontAwesomeIcons.whatsapp),
      );
    } else if(model.blocks.settings.chatType == 'call') {
      return FloatingActionButton(
        onPressed: () => _launch('tel:' + model.blocks.settings.phoneNumber),
        tooltip: 'Chat',
        child: Icon(FontAwesomeIcons.phone),
      );
    } if(model.blocks.settings.chatType == 'message') {
      return FloatingActionButton(
        onPressed: () => _launch('sms:' + model.blocks.settings.phoneNumber),
        tooltip: 'Chat',
        child: Icon(Icons.chat_bubble),
      );
    } if(model.blocks.settings.chatType == 'mail') {
      return FloatingActionButton(
        onPressed: () => _launch('mailto:' + model.blocks.settings.email),
        tooltip: 'Chat',
        child: Icon(Icons.email),
      );
    } if(model.blocks.settings.chatType == 'messenger') {
      return FloatingActionButton(
        onPressed: () => _launch('https://m.me/' + model.blocks.settings.fbPageName),
        tooltip: 'Chat',
        child: Icon(FontAwesomeIcons.facebook),
      );
    } if(model.blocks.settings.chatType == 'firebaseChat') {
      return FloatingActionButton(
        onPressed: () => _fireBaseChat(context),
        tooltip: 'Chat',
        child: Icon(Icons.chat_bubble),
      );
    } if(model.blocks.settings.chatType == 'circular') {
      return FabCircularMenu(
          fabOpenColor: secondary,
          fabCloseColor: secondary,
          fabOpenIcon: Icon(
            Icons.chat_bubble,
            color: onSecondary,
          ),
          fabMargin: EdgeInsets.all(12),
          fabCloseIcon: Icon(
            Icons.close,
            color: onSecondary,
          ),
          //child: Container(),
          ringColor: secondary,
          ringDiameter: 250.0,
          ringWidth: 100.0,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.chat_bubble,
                  color: onSecondary,
                ),
                onPressed: () => _fireBaseChat(context),
                iconSize: 20.0,
                color: Colors.black),
                if(model.blocks.settings.email.isNotEmpty)
            IconButton(
                icon: Icon(
                  Icons.mail,
                  color: onSecondary,
                ),
                onPressed: () {
                  _launch('mailto:'+model.blocks.settings.email);
                },
                iconSize: 20.0,
                color: Colors.black),
            IconButton(
                icon: Icon(
                  FontAwesomeIcons.whatsapp,
                  color: onSecondary,
                ),
                onPressed: () => _launch('https://wa.me/' + model.blocks.settings.phoneNumber),
                iconSize: 20.0,
                color: Colors.black),
            IconButton(
                icon: Icon(
                  Icons.call,
                  color: onSecondary,
                ),
                onPressed: () {
                  _launch('tel:' + model.blocks.settings.phoneNumber);
                },
                iconSize: 20.0,
                color: Colors.black),
          ]);
    } else return Container();
  }

  _launch(url) async {
    launch(url);
    //canLaunch not working for some android device
    /*if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }*/
  }

  _fireBaseChat(BuildContext context) {
    if (model.user.id > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdminChatPage(
                  userId:
                  model.user.id.toString())));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Login()));
    }
  }
}
