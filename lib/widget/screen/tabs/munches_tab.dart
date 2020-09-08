import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/util/custom_button.dart';

class MunchesTab extends StatefulWidget {
  @override
  _MunchesTabState createState() => _MunchesTabState();
}

class _MunchesTabState extends State<MunchesTab> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             Row(
               mainAxisSize: MainAxisSize.max,
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Text(App.translate("munches_tab.title"), style: AppTextStyle.style(AppTextStylePattern.heading2)),
                 _plusButton(context)
               ],
             ),
             Align(
                alignment: Alignment.centerLeft,
                child:  DefaultTabController(
                    length: 2,
                    child: TabBar(
                      onTap: (int index){
                        setState(() {
                          _currentTab = index;
                        });
                      },
                      isScrollable: true, // needs to be set to true in order to make Align widget workable
                      labelColor: Palette.primary,
                      unselectedLabelColor: Palette.secondaryLight,
                      indicatorColor: Palette.primary,
                      indicatorPadding: EdgeInsets.only(left:0.0, right: 15.0),
                      labelPadding: EdgeInsets.only(left:0.0, right: 15.0),
                      labelStyle: AppTextStyle.style(AppTextStylePattern.body3),
                      tabs: [
                        Tab(text: App.translate("munches_tab.deciding_tab.title")),
                        Tab(text: App.translate("munches_tab.decided_tab.title")),
                      ],
                    )
                )
             ),
             // IndexedStack must be used instead of TabBarView, because we need unbounded height
             IndexedStack(
               index: _currentTab,
               children: <Widget>[
                 ListView(primary: true, shrinkWrap: true),
                 ListView(primary: true, shrinkWrap: true),
               ],
             )
          ],
        ),
    );
  }

  void _onPlusButtonClicked(){

  }

  Widget _plusButton(BuildContext context){
    return CustomButton(
      color: Palette.background,
      content: Icon(
        Icons.add,
        size: 30,
        color: Palette.secondaryDark,
      ),
      flat: true,
      onPressedCallback: _onPlusButtonClicked,
    );
  }

}