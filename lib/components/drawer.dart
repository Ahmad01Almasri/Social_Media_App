import 'package:flutter/material.dart';
import 'package:social_media/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onPerofiletap;
  final void Function()? onLogouttap;
  const MyDrawer({super.key, this.onPerofiletap, this.onLogouttap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          const DrawerHeader(
              child: Icon(
            Icons.person,
            color: Colors.white,
            size: 60,
          )),
          MyListTitel(
            icon: Icons.home,
            text: 'H O M E',
            ontap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          MyListTitel(
              icon: Icons.person, text: 'P R O F I L E', ontap: onPerofiletap),
          const SizedBox(
            height: 20,
          ),
          MyListTitel(
              icon: Icons.logout, text: 'L O G O U T', ontap: onLogouttap)
        ],
      ),
    );
  }
}
