part of date_time_picker_form_field;

class DateTimePickerController extends ValueNotifier<DateTimePickerValues> {
  DateTimePickerController() : super(DateTimePickerValues());
  DateTime? get date => value.date;
  TimeOfDay? get time => value.time;
}
