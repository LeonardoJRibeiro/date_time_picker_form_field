part of date_time_picker_form_field;

class DateTimePickerFormField extends FormField<DateTime?> {
  DateTimePickerFormField({
    Key? key,
    FocusNode? focusNode,

    ///The decoration of input
    InputDecoration? decoration,

    ///Is the earliest allowable date.
    required DateTime firstDate,
    //Is the latest allowable date.
    required DateTime lastDate,

    ///Controller thats keep the date or time pickeds, it extends [ValueNotifier] and can be used with a ValueListenableBuild to display the values stored in its state without a [setState].
    required DateTimePickerController controller,

    ///An optional method that validates an input. Returns an error string to display if the input is invalid, or null otherwise.
    String? Function(DateTime? dateTime)? validator,

    ///The initial value. It will be changed on future to 'initialDate' and 'initialTime'.
    DateTime? initialDateTime,

    ///The picker will pick only date wehn true.
    bool onlyDate = false,

    ///The picker will pick only time wehn true.
    bool onlyTime = false,
  })  : assert(!onlyDate || !onlyTime),
        super(
          key: key,
          validator: (_) => validator?.call(controller.dateAndTime),
          builder: (field) {
            return ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, child) => DateTimePicker(
                focusNode: focusNode ?? FocusNode(),
                controller: controller,
                firstDate: firstDate,
                lastDate: lastDate,
                decoration: decoration,
                onlyDate: onlyDate,
                onlyTime: onlyTime,
                error: field.errorText,
              ),
            );
          },
        ) {
    if (initialDateTime != null) {
      controller.value = DateTimePickerValues(
        date: DateTime(
          initialDateTime.year,
          initialDateTime.month,
          initialDateTime.day,
        ),
        time: TimeOfDay(
          hour: initialDateTime.hour,
          minute: initialDateTime.minute,
        ),
      );
    }
  }
}

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({
    Key? key,
    required this.focusNode,
    this.decoration,
    this.error,
    required this.firstDate,
    required this.lastDate,
    required this.controller,
    required this.onlyDate,
    required this.onlyTime,
  }) : super(key: key);

  final FocusNode focusNode;
  final InputDecoration? decoration;
  final String? error;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimePickerController controller;
  final bool onlyDate;
  final bool onlyTime;
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  bool _isHovering = false;

  void _handleFocusChange() {
    setState(() {});
  }

  void _handleHover(bool hover) {
    setState(() {
      _isHovering = hover;
    });
  }

  @override
  void initState() {
    widget.focusNode.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    widget.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return InkWell(
      focusNode: widget.focusNode,
      onTap: () async {
        DateTime? date;
        TimeOfDay? time;
        if (!widget.onlyTime) {
          date = await showDatePicker(
            context: context,
            initialDate: widget.controller.dateTime ?? DateTime.now(),
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
          );
        }
        if (!widget.onlyDate) {
          time = await showTimePicker(
            context: context,
            initialTime: widget.controller.time ?? TimeOfDay.now(),
          );
        }
        if (widget.onlyDate && date != null) {
          widget.controller.value = DateTimePickerValues(
            date: date,
          );
        } else if (widget.onlyTime && time != null) {
          widget.controller.value = DateTimePickerValues(
            time: time,
          );
        } else if (date != null && time != null) {
          widget.controller.value = DateTimePickerValues(
            date: date,
            time: time,
          );
        }
      },
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: InputDecorator(
          decoration: (widget.decoration ?? const InputDecoration())
              .applyDefaults(Theme.of(context).inputDecorationTheme)
              .copyWith(
                errorText: widget.error,
              ),
          isFocused: widget.focusNode.hasFocus,
          isHovering: _isHovering,
          isEmpty: widget.controller.dateAndTime == null,
          child: Text(
            widget.controller.dateAndTime != null
                ? '${localizations.formatCompactDate(widget.controller.dateAndTime!)} ${localizations.formatTimeOfDay(widget.controller.time!)}'
                : '',
          ),
        ),
      ),
    );
  }
}
