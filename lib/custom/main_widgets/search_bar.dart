import 'package:flutter/material.dart';
import 'package:mywine/custom/main_widgets/card.dart';
import 'package:animate_icons/animate_icons.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required this.context,
    required this.onChange,
    this.icon,
    this.autofocus = false,
    this.placeholder = "bourgogne, saint-émilion...",
    this.focusNode,
    this.hidden = false,
    this.autofill,
  }) : super(key: key);

  final BuildContext context;
  final FocusNode? focusNode;
  final String placeholder;
  final Function onChange;
  final IconData? icon;
  final bool autofocus;
  final bool hidden;
  final List<String>? autofill;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late AnimateIconController _iconController;
  late TextEditingController _textController;

  @override
  void initState() {
    _iconController = AnimateIconController();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.all(0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
                controller: _textController,
                obscureText: widget.hidden,
                autofillHints: widget.autofill,
                onChanged: (value) {
                  if (value.length > 0) {
                    _iconController.animateToEnd();
                  } else {
                    _iconController.animateToStart();
                  }

                  return widget.onChange(value);
                },
                cursorColor: Theme.of(context).hintColor,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
                decoration: InputDecoration(
                  hintText: widget.placeholder,
                  hintStyle:
                      TextStyle(color: Colors.grey.shade500, fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 20),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _clearTextField(),
              child: Container(
                color: Theme.of(context).hintColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimateIcons(
                    duration: Duration(milliseconds: 200),
                    startIcon: widget.icon ?? Icons.search_outlined,
                    endIcon: Icons.close,
                    startIconColor: Colors.white,
                    endIconColor: Colors.white,
                    controller: _iconController,
                    onStartIconPress: () => false,
                    onEndIconPress: () {
                      _clearTextField();
                      return false;
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _clearTextField() {
    _textController.clear();
    widget.onChange("");
    _iconController.animateToStart();
  }
}
