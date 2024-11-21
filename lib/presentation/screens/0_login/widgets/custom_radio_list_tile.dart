import 'package:flutter/material.dart';

class CustomRadioListTile<T> extends StatefulWidget {
  final T groupValue;
  final T value1;
  final String label1;
  final T value2;
  final String label2;
  final String radioName;
  final ValueChanged<T> onChanged;

  const CustomRadioListTile({
    super.key,
    required this.label1,
    required this.label2,
    required this.value1,
    required this.value2,
    required this.groupValue,
    required this.radioName,
    required this.onChanged,
  });

  @override
  State<CustomRadioListTile> createState() => _CustomRadioListTileState<T>();
}

class _CustomRadioListTileState<T> extends State<CustomRadioListTile<T>> {
  late T _groupValue;

  @override
  void initState() {
    super.initState();
    _groupValue = widget.groupValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.radioName,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Row(
          children: [
            Flexible(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RadioListTile<T>(
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(widget.label1),
                  ),
                  value: widget.value1,
                  groupValue: _groupValue,
                  onChanged: (T? value) {
                    setState(() {
                      _groupValue = value as T;
                      widget.onChanged(_groupValue);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RadioListTile<T>(
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(widget.label2),
                  ),
                  value: widget.value2,
                  groupValue: _groupValue,
                  onChanged: (T? value) {
                    setState(() {
                      _groupValue = value as T;
                      widget.onChanged(_groupValue);
                    });
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
