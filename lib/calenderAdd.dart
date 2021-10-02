import 'package:add_2_calendar/add_2_calendar.dart';
// TODO: Time format is : (year, month, day, hour, minute) (24 hour clock)

void AddCalender(int syear, int smonth, int sday, int shour, int sminute,
    int eyear, int emonth, int eday, int ehour, int eminute) {
  final Event event = Event(
    title: 'Event title',
    description: 'Event description',
    location: 'Event location',
    startDate: DateTime(syear, smonth, sday, shour, sminute),
    endDate: DateTime(eyear, emonth, eday, ehour, eminute),
  );

  Add2Calendar.addEvent2Cal(event);
}
