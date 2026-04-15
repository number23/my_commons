import 'package:flutter/material.dart';

Widget buildCheckboxes({
  required Color activeColor,
  required Map<String, String> displayMap,
  required List<String> selectedList,
  required Function callbackFn,
}) {
  return Padding(
    padding: const .symmetric(horizontal: 8, vertical: 2),
    child: Wrap(
      spacing: 8.0, // 复选框之间的水平间距
      runSpacing: 2.0, // 换行后的垂直间距
      children: displayMap.entries.map((entry) {
        return Row(
          mainAxisSize: .min,
          children: [
            Checkbox(
              value: selectedList.contains(entry.key),
              activeColor: activeColor,
              materialTapTargetSize: .shrinkWrap,
              visualDensity: .compact, //紧凑模式
              onChanged: (bool? isChecked) {
                if (isChecked == null) return;
                if (isChecked) {
                  selectedList.add(entry.key);
                } else {
                  selectedList.remove(entry.key);
                }
                callbackFn();
              },
            ),
            Text(entry.value, style: const TextStyle(fontSize: 14)),
          ],
        );
      }).toList(),
    ),
  );
}

Widget buildDropdownList({
  required int? selected,
  required int? init,
  required Map<int, String> displayMap,
  required void Function(int?) callbackFn,
  bool enabled = true,
}) {
  final textStyle = TextStyle(
    fontSize: 13,
    color: enabled ? Colors.black : Colors.grey.shade400,
    fontWeight: FontWeight.normal,
  );
  return DropdownButtonFormField<int?>(
    initialValue: selected,
    isExpanded: true,
    style: textStyle,
    decoration: InputDecoration(
      hintText: '請選擇',
      hintStyle: textStyle.copyWith(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: -2),
      enabledBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      border: InputBorder.none, //不要边框
    ),
    items: displayMap.entries.map((entry) {
      return DropdownMenuItem<int?>(
        value: entry.key,
        child: SizedBox(
          child: Align(
            heightFactor: 0,
            alignment: .centerLeft,
            child: Text(entry.value, style: textStyle),
          ),
        ),
      );
    }).toList(),
    onChanged: enabled ? callbackFn : null,
  );
}
