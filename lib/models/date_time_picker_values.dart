part of date_time_picker_form_field;

class DateTimePickerValues {
  DateTimePickerValues({
    this.date,
    this.time,
  });

  DateTime? date;
  TimeOfDay? time;

  DateTimePickerValues copyWith({
    DateTime? date,
    TimeOfDay? time,
  }) {
    return DateTimePickerValues(
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DateTimePickerValues &&
        other.date == date &&
        other.time == time;
  }

  @override
  int get hashCode => date.hashCode ^ time.hashCode;
}
