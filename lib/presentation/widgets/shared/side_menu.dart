import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../presentation/provider/auth/auth_provider.dart';
import '../../../presentation/widgets/shared/shared.dart';

//--- is use on drawer Widget
class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({super.key, required this.scaffoldKey});

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {

    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;
    final user = ref.watch(authProvider).user;

    return NavigationDrawer(
        elevation: 1,
        selectedIndex: navDrawerIndex,
        onDestinationSelected: (value) {
          setState(() {
 // is active when NavigationDrawerDestination Products is pressed and after close drawer
            navDrawerIndex = value;
          });
          widget.scaffoldKey.currentState?.closeDrawer();
        },
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, hasNotch ? 20 : 20, 16, 0),
            child: Text('Welcome', style: textStyles.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 16, 10),
            child: Text(user?.fullName ?? '', style: textStyles.titleSmall),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.home_outlined),
            label: Text('Products'),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
            child: Text('Other options'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomFilledButton(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                },
                text: 'Logout'),
          ),
        ]);
  }
}
