import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/features/home/widgets/side_menu.dart';
import 'package:todo_flutter/providers/drawer_controller.dart';

class MainScreen extends StatelessWidget {
  static const routName = '/main-screen';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            const Center(
              child: Text(
                'Welcome back!',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Lottie.asset(
              'assets/animations/tasks.json',
            ),
          ],
        ),
      ),
    );
  }
}
