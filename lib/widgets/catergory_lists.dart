import 'package:fin_track/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatergoryLists extends StatefulWidget {
  const CatergoryLists({super.key, required this.onChanged});

  final ValueChanged<String?> onChanged;

  @override
  State<CatergoryLists> createState() => _CatergoryListsState();
}

class _CatergoryListsState extends State<CatergoryLists> {
  String currentCatergory = "";

  final AppIcons appIcons = AppIcons();

  final ScrollController scrollController = ScrollController();

  List<Map<String, dynamic>> catList = [];

  @override
  void initState() {
    super.initState();

    catList = appIcons.homeExpenseCatergory;

    catList.insert(0, addCat);
  }

  var addCat = {
    "name": "All",
    "icon": FontAwesomeIcons.cartPlus,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
          itemCount: catList.length,
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          itemBuilder: (context, index) {
            var data = catList[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentCatergory = data['name'];
                  widget.onChanged(data['name']);
                });
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: currentCatergory == data['name']
                      ? Colors.blue.shade400
                      : Colors.deepOrange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      data['icon'],
                      size: 17,
                      color: currentCatergory == data['name']
                          ? Colors.white
                          : Colors.black,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      data['name'],
                      style: TextStyle(
                        fontWeight: currentCatergory == data['name']
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: currentCatergory == data['name']
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
