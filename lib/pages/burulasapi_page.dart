import 'package:fetchingburulasapi/pages/widgets/bus_search_widget.dart';
import 'package:flutter/material.dart';

class BurulasAPIPage extends StatelessWidget {
  const BurulasAPIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Container(
              margin: const EdgeInsets.all(5.0),
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () {
                  showSearch(context: context, delegate: BusSearchComponent());
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  decoration: const BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: const Row(
                    children: [
                      Icon(Icons.search_rounded),
                      SizedBox(width: 15.0),
                      Text("Arama yapmak için tıklayın...",
                          style: TextStyle(
                            fontSize: 18.0,
                          ))
                    ],
                  ),
                ),
              )),
        )
      ],
    );
  }
}
