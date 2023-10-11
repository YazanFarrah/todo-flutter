import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_flutter/features/auth/services/auth.dart';
import 'package:todo_flutter/features/home/screens/completed_tasks.dart';
import 'package:todo_flutter/features/home/screens/home_screen.dart';
import 'package:todo_flutter/features/home/services/home.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        children: [
          DrawerHeader(
            child: Lottie.asset(
              "assets/animations/myTasks.json",
              height: 150,
              width: 150,
            ),
          ),
          DrawerListTile(
            title: 'All Todos',
            icon: Icons.all_inbox,
            press: () {
              Navigator.pushNamed(context, HomeScreen.routName);
              Scaffold.of(context).closeDrawer();
            },
          ),
          DrawerListTile(
            title: 'Completed Todos',
            icon: Icons.task,
            press: () {
              Navigator.pushNamed(context, CompletedTasks.routName);
              Scaffold.of(context).closeDrawer();
            },
          ),
          const Divider(
            endIndent: 15,
            indent: 15,
          ),
          DrawerListTile(
            title: 'Logout',
            icon: Icons.logout_outlined,
            press: () async {
              await AuthServices().logout(context);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.press,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final VoidCallback press;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: trailing ?? const SizedBox.shrink(),
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(
          icon,
          color: Colors.deepPurple, // Use a high-contrast color for the icon
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black, // Use a high-contrast color for the text
        ),
      ),
    );
  }
}
