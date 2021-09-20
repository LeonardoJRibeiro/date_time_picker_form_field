part of date_time_picker_form_field;

class DateTimePickerController extends ValueNotifier<DateTimePickerValues> {
  DateTimePickerController() : super(DateTimePickerValues());
  DateTime? get dateTime => value.date;
  TimeOfDay? get time => value.time;
  DateTime? get dateAndTime => dateTime != null && time != null
      ? DateTime(
          dateTime!.year,
          dateTime!.month,
          dateTime!.day,
          time!.hour,
          time!.minute,
        )
      : null;
}
