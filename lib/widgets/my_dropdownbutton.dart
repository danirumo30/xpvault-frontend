import 'package:flutter/material.dart';
import 'package:xpvault/themes/app_color.dart';

class MyDropdownbutton extends StatelessWidget {
  final List<DropdownMenuItem<String>>? items;
  final void Function(String?)? onChanged;
  final String? value;
  final String hint;

  const MyDropdownbutton({
    super.key,
    this.items,
    this.onChanged,
    this.value, required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: AppColors.secondary,
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(hint,style: TextStyle(color: AppColors.textPrimary),),
            value: value,
            items: items,
            onChanged: onChanged,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
            dropdownColor: AppColors.background,
            iconEnabledColor: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
