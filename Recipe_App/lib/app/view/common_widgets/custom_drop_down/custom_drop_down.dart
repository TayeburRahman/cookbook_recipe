import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdown extends StatelessWidget {
  final String title;
  final RxString selectedValue;
  final RxBool isDropdownOpen;
  final List<String> items;
  final void Function() onToggle;
  final void Function(String) onSelect;

  const CustomDropdown({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.isDropdownOpen,
    required this.items,
    required this.onToggle,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black)),
        const SizedBox(height: 8),
        Obx(() => GestureDetector(
              onTap: onToggle,
              child: TextField(
                decoration: InputDecoration(
                  hintText: selectedValue.value,
                  suffixIcon: IconButton(
                    onPressed: onToggle,
                    icon: const Icon(Icons.arrow_drop_down_sharp),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                readOnly: true,
              ),
            )),
        Obx(() => isDropdownOpen.value
            ? Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: items
                      .map((item) => InkWell(
                            onTap: () => onSelect(item),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                children: [
                                  Text(item,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  if (items.indexOf(item) != items.length - 1)
                                    const Divider(),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              )
            : const SizedBox()),
      ],
    );
  }
}
