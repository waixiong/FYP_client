import 'package:flutter/material.dart';
import 'package:imageChat/view/pages/optical_label_page.dart';
import '../common/nav/SecretImageTopBar.dart';
import '../common/nav/QrCodeTopBar.dart';
import 'package:imageChat/view/pages/chats_list_page.dart';
import '../common/nav/5n_bottom_bar.dart';
import '../pages/profile.dart';
import 'secret_image_page.dart';

class MyHome extends StatelessWidget {
  final bottomNav = FiveNBottomBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: bottomNav,

      /// Testing
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'Text'),
      //     BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'Text'),
      //   ],
      // ),

      body: StreamBuilder(
        initialData: 1,
        stream: bottomNav.pageIndexStream,
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data == null) return Container();

          return IndexedStack(
            index: snapshot.data,
            children: [
              ChatList(),
              // SecretImageTopBar(),
              SecretImagePage(),
              // QRCodeTopBar(),
              OpticalLabelPage(),
              ProfileLayout(),
            ],
          );
        },
      ),
    );
  }
}

// LayoutBuilder(
//       builder: (context, constraints) {
//         return constraints.maxWidth < desktopCutoff
//           ? MobileHome()
//           : DesktopHome();
//       },
//     );