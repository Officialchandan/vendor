import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GridViewPractice extends StatefulWidget {
  const GridViewPractice({Key? key}) : super(key: key);

  @override
  _GridViewPracticeState createState() => _GridViewPracticeState();
}

class _GridViewPracticeState extends State<GridViewPractice> {
  List<String> name = [
    "Billing",
    "Inventory",
    "Online Shop",
    "Staff Management",
    "Performance Tracker",
    "Account Management"
  ];
  List<String> description = [
    "Billing description",
    "Inventory description",
    "Online Shop description",
    "Staff Management description",
    "Performance Tracker description",
    "Account Management description"
  ];

  List<String> images = [
    "assets/images/home2.png",
    "assets/images/home2.png",
    "assets/images/home2.png",
    "assets/images/home2.png",
    "assets/images/home2.png",
    "assets/images/home2.png"
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    //print(size);
    //final double itemHeight = size * 0.20;
    // MediaQueryData queryData;
    // queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      body: StaggeredGridView.countBuilder(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
        crossAxisCount: 2,
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) => new Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: index == 0
                ? Colors.indigoAccent
                : index == 1
                    ? Colors.purple
                    : index == 2
                        ? Colors.pink.shade300
                        : index == 3
                            ? Colors.blue.shade400
                            : index == 4
                                ? Colors.orange
                                : index == 5
                                    ? Colors.green.shade300
                                    : Colors.brown,
            //index.isEven ? Colors.indigoAccent : Colors.indigoAccent[100],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    name[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    description[index],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    images[index],
                    height: 50,
                    width: 50,
                  ))
            ],
          ),
        ),
        staggeredTileBuilder: (int index) => StaggeredTile.count(
          1 // it specifies the number of columns,
          ,
          index == 0
              ? size / 500
              : index == 1
                  ? size / 600
                  : index == 2
                      ? size / 500
                      : index == 3
                          ? size / 600
                          : index == 4
                              ? size / 550
                              : index == 5
                                  ? size / 550
                                  : 0.0,
        ),
        mainAxisSpacing: 30.0,
        crossAxisSpacing: 20.0,
      ),
    );
  }
}
