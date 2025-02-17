import 'package:fin_track/main.dart';
import 'package:fin_track/utils/app_icons.dart';
import 'package:flutter/material.dart';

class CategoryDropdown extends StatefulWidget {
  const CategoryDropdown({super.key, this.catType, this.onChanged});
  final String? catType;
  final ValueChanged<String?>? onChanged; // Ensure correct type

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    // Extract category names to check validity
    final categoryNames =
        appIcons.homeExpenseCatergory.map((e) => e["name"] as String).toSet();

    // Ensure `widget.catType` is either null or a valid value
    final selectedValue =
        categoryNames.contains(widget.catType) ? widget.catType : null;

    return DropdownButton<String>(
      hint: const Text("Select Category"),
      value: selectedValue, // Use validated value
      isExpanded: true,
      items: categoryNames
          .map(
            (name) => DropdownMenuItem<String>(
              value: name,
              child: Row(
                children: [
                  Icon(
                    appIcons.homeExpenseCatergory
                        .firstWhere((e) => e["name"] == name)["icon"],
                    size: 24,
                    color: Colors.pink.shade200,
                  ),
                  SizedBox(width: mq.width * .05),
                  Text(name),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: widget.onChanged,
    );
  }
}
