import 'package:flutter/material.dart';

class TabBarButton extends StatelessWidget {
  final Widget child;
  final void Function() onClick;
  final BoxDecoration? decoration;
  final Icon? icon;

  const TabBarButton({super.key, required this.child, required this.onClick, this.icon, this.decoration = const BoxDecoration(
      color: Colors.black45,
      borderRadius: BorderRadius.all(Radius.circular(5.0))) });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      onTap: () {
        onClick();
      },
      child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: decoration,
          child: child
      ),
    );
  }
}


class CustomTabBar extends StatefulWidget{
  final List<Widget> tabs;
  final List<Widget> views;
  final void Function(int index)? onViewLoad;

  const CustomTabBar({super.key, required this.tabs, required this.views, this.onViewLoad});

  @override
  CustomBarState createState() => CustomBarState();

}

class CustomBarState extends State<CustomTabBar>{
  int selectedView = 0;

  @override
  Widget build(BuildContext context) {
    if(widget.onViewLoad != null) widget.onViewLoad!(selectedView);

    if(widget.tabs.length != widget.views.length) throw Exception("EqualException: Tabs and Views count must be equal.");

    final List<Widget> tabWidget = [];

    for (int i = 0; i < widget.tabs.length; i++) {
      tabWidget.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: TabBarButton(
            onClick: () {
              if(selectedView != i) {
                setState(() {
                  selectedView = i;
                });
              }
            }, decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: (selectedView == i) ? Colors.deepPurple : Colors.black45
        ), child: widget.tabs[i]),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: tabWidget
            ),
        ),
        //views
        Expanded(child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: widget.views[selectedView],
        ))
      ],
    );
  }

}