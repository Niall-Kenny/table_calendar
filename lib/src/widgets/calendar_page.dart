// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';

class CalendarPage extends StatelessWidget {
  final Widget Function(BuildContext context, DateTime day)? dowBuilder;
  final Widget Function(BuildContext context, DateTime day) dayBuilder;
  final List<DateTime> visibleDays;
  final Decoration? dowDecoration;
  final Decoration? rowDecoration;
  final bool dowVisible;

  /// list of weekdays to show as columns. e.g. `[DateTime.monday, DateTime.tuesday ...]`
  final List<int> daysToShow;

  const CalendarPage({
    Key? key,
    required this.visibleDays,
    this.dowBuilder,
    required this.dayBuilder,
    this.dowDecoration,
    this.rowDecoration,
    this.dowVisible = true,
    required this.daysToShow,
  })   : assert(!dowVisible || dowBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        if (dowVisible) _buildDaysOfWeek(context),
        ..._buildCalendarDays(context),
      ],
    );
  }

  TableRow _buildDaysOfWeek(BuildContext context) {
    return TableRow(
      decoration: dowDecoration,
      children: List.generate(
        daysToShow.length,
        (index) => dowBuilder!(context, visibleDays[index]),
      ).toList(),
    );
  }

  List<TableRow> _buildCalendarDays(BuildContext context) {
    final rowAmount = visibleDays.length ~/ 7;

    // print(List.generate(rowAmount, (index) => index * 5).map((index) => List.generate(
    //             5,
    //             (id) => visibleDays[index + id],
    //           )));

    // Original return value
    //  List.generate(rowAmount, (index) => index * 7)
    //     .map((index) => TableRow(
    //           decoration: rowDecoration,
    //           children: List.generate(
    //             5,
    //             (id) => dayBuilder(context, visibleDays[index + id]),
    //           ),
    //         ))
    //     .toList();

    var newList = List.generate(rowAmount, (index) => index * 7);
    List<List<DateTime>> month = [];
    newList.forEach((index) {
      month.add(List.generate(
        7,
        (id) => visibleDays[index + id],
      ));
    });

    List<List<DateTime>> dayColumnsToShowOnScreen = [];
    month.forEach((week) => dayColumnsToShowOnScreen
        .add(week.where((date) => daysToShow.contains(date.weekday)).toList()));
    return dayColumnsToShowOnScreen
        .map((e) => TableRow(
            decoration: rowDecoration,
            children: e
                .map(
                  (date) => dayBuilder(context, date),
                )
                .toList()))
        .toList();
  }
}
