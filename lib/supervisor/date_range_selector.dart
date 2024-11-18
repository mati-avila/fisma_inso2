// lib/widgets/dashboard/date_range_selector.dart
import 'package:flutter/material.dart';

class DateRangeSelector extends StatelessWidget {
  final void Function(DateTime start, DateTime end) onDateRangeSelected;

  const DateRangeSelector({
    Key? key,
    required this.onDateRangeSelected,
  }) : super(key: key);

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? selectedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blueAccent,
            scaffoldBackgroundColor: Colors.blueAccent,
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDateRange != null) {
      onDateRangeSelected(
        selectedDateRange.start,
        selectedDateRange.end,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectDateRange(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        textStyle: const TextStyle(fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('Filtrar por Fecha'),
    );
  }
}