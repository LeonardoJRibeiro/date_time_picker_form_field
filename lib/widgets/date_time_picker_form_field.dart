part of date_time_picker_form_field;

class DateTimePickerFormField extends FormField<DateTime?> {
  DateTimePickerFormField({
    Key? key,
    FocusNode? focusNode,
    InputDecoration? decoration,
    required DateTime firstDate,
    required DateTime lastDate,
    required DateTimePickerController controller,
    String? Function(DateTime? dateTime)? validator,
    DateTime? initialDateTime,
  }) : super(
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
  }) : super(key: key);

  final FocusNode focusNode;
  final InputDecoration? decoration;
  final String? error;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimePickerController controller;
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
        final date = await showDatePicker(
          context: context,
          initialDate: widget.controller.dateTime ?? DateTime.now(),
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
        );
        final time = await showTimePicker(
          context: context,
          initialTime: widget.controller.time ?? TimeOfDay.now(),
        );
        if (date != null && time != null) {
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
