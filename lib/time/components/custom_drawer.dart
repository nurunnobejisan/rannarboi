import 'package:flutter/material.dart';
import 'package:cookbook/time/components/intro_slider.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const Center(
            child: UserAccountsDrawerHeader(
              accountName: Text("User"),
              accountEmail: Text("Email"),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          ),
          ListTile(
              title: const Text("Timer"),
              leading: const Icon(Icons.timer),
              onTap: () {
                Navigator.pushNamed(context, '/');
              }),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text("Recipes"),
            onTap: () {
              Navigator.pushNamed(context, 'recipes');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text("Help"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => HelpSlider())),
          ),
          const Spacer(
            flex: 4,
          ),
          const Divider(),
          ListTile(
            title: Center(child: Text("Privacy Policy",
                style: Theme.of(context).textTheme.caption),),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => PrivacyPolicy())),
          )
        ],
      ),
    );
  }
//remove
  PrivacyPolicy() {}
}
