import 'package:provider/provider.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';
import 'package:tt/myThemeData.dart';
import 'package:tt/providers/lang_mode.dart';
import 'package:tt/screens/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tt/screens/upload.dart';
import 'package:tt/widegets/sideMenu.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int selectedIndex = 0;
  PageController _controller = PageController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang_modeProvider provider = Provider.of(context);
    String currentMode = provider.appMode;
    return Scaffold(
      drawer: sideMenu(),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.qura2,
            style: lightTheme.LightThemeData.appBarTheme.toolbarTextStyle),
        centerTitle: true,
      ),
      body: provider.appLanguage == 'ar'
          ? PageView(controller: _controller, children: [record(), upload()])
          : PageView(controller: _controller, children: [upload(), record()]),
      extendBody: true,
      bottomNavigationBar: RollingBottomBar(
        color: currentMode == 'light'
            ? lightTheme.LightThemeData.accentColor
            : DarkTheme.DarkThemeData.primaryColor,
        controller: _controller,
        activeItemColor: lightTheme.LightThemeData.primaryColor,
        itemColor: lightTheme.LightThemeData.primaryColor,
        onTap: (index) {
          _controller.animateToPage(index,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOutQuad);
        },
        items: [
          //record
          provider.appLanguage == 'ar'
              ? RollingBottomBarItem(
                  Icons.mic,
                  label: AppLocalizations.of(context)!.record,
                )
              : RollingBottomBarItem(
                  Icons.upload,
                  label: AppLocalizations.of(context)!.upload,
                ),
          provider.appLanguage == 'ar'
              ? RollingBottomBarItem(
                  Icons.upload,
                  label: AppLocalizations.of(context)!.upload,
                )
              : RollingBottomBarItem(
                  Icons.mic,
                  label: AppLocalizations.of(context)!.record,
                )
        ],
        enableIconRotation: true,
      ),
    );
//ordinary nav bar
    /*     BottomNavigationBar(
        elevation: 20,
        currentIndex: selectedIndex,
        //bug dont change selected item color
        //bug dont chabge direction when language changed (solved)
        //   selectedItemColor: Color.fromARGB(210, 210, 38, 38),
        onTap: (index) {
          selectedIndex = index;
          setState(() {});
        },
        items: [
          //record
          provider.appLanguage == 'ar'
              ? BottomNavigationBarItem(
                  icon: Icon(Icons.mic),
                  label: 'record',
                )
              : BottomNavigationBarItem(
                  icon: Icon(
                    Icons.upload,
                  ),
                  label: 'upload',
                ),
          //upload
          provider.appLanguage == 'ar'
              ? BottomNavigationBarItem(
                  icon: Icon(Icons.upload),
                  label: 'upload',
                )
              : BottomNavigationBarItem(
                  icon: Icon(Icons.mic),
                  label: 'record',
                ),
        ],
      ),
  
        );
  }*/
  }
}
