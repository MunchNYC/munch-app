import 'package:flutter/material.dart';
import 'package:munch/model/munch.dart';
import 'package:munch/theme/palette.dart';
import 'package:munch/theme/text_style.dart';
import 'package:munch/util/app.dart';
import 'package:munch/widget/screen/home/include/create_join_dialog.dart';
import 'package:munch/widget/screen/home/tabs/munch_list_widget.dart';
import 'package:munch/widget/util/custom_button.dart';
import 'package:munch/widget/util/dialog_helper.dart';

class MunchesTab extends StatefulWidget {
  @override
  _MunchesTabState createState() => _MunchesTabState();
}

class _MunchesTabState extends State<MunchesTab> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
           _headerBar(),
           _tabHeaders(),
           // IndexedStack must be used instead of TabBarView, because we need unbounded height
           Expanded(child: _tabsContent())
        ]
    );
  }

  Widget _headerBar(){
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(App.translate("munches_tab.title"), style: AppTextStyle.style(AppTextStylePattern.heading2)),
          _plusButton(context)
        ],
      );
  }

  Widget _tabHeaders(){
    return Align(
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
    );
  }

  Widget _tabsContent(){
    return IndexedStack(
        index: _currentTab,
        children: <Widget>[
          _munchesListView(context, states: [MunchState.DECIDING]),
          _munchesListView(context, states: [MunchState.DECIDED, MunchState.ARCHIVED]),
        ]
    );
  }

  Widget _munchesListView(BuildContext context, {List<MunchState> states}){
     return ListView.separated(
         itemCount: 12,
         itemBuilder: (BuildContext context, int index){
           return MunchListWidget();
         },
         padding: EdgeInsets.symmetric(vertical: 20.0),
         separatorBuilder: (BuildContext context, int index) {
           return Divider(height: 40.0, thickness: 1.5, color: Palette.secondaryLight.withOpacity(0.5));
         },
     );
  }

  void _onPlusButtonClicked(BuildContext context){
    DialogHelper(dialogContent: CreateJoinDialog(), showCloseIcon: false).show(context);
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
      onPressedCallback: () => _onPlusButtonClicked(context),
    );
  }

}