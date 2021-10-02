import 'package:add_2_calendar/add_2_calendar.dart';
// TODO: Time format is : (year, month, day, hour, minute) (24 hour clock)

void newthing() {
  final Event event = Event(
    title: 'Event title',
    description: 'Event description',
    location: 'Event location',
    startDate: DateTime(2021, 6, 6, 13, 45),
    endDate: DateTime(2021, 8, 5),
  );

  Add2Calendar.addEvent2Cal(event);
}
