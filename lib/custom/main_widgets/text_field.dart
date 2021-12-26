import 'package:flutter/material.dart';
import 'package:mywine/custom/main_widgets/card.dart';
import 'package:animate_icons/animate_icons.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    Key? key,
    required this.context,
    required this.onChange,
    this.autofocus = false,
    this.placeholder = "bourgogne, saint-émilion...",
    this.focusNode,
  }) : super(key: key);

  final BuildContext context;
  final FocusNode? focusNode;
  final String placeholder;
  final Function onChange;
  final bool autofocus;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
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
                    startIcon: Icons.search_outlined,
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

class CustomTextFieldWithIcon extends StatefulWidget {
  const CustomTextFieldWithIcon({
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
  State<CustomTextFieldWithIcon> createState() =>
      _CustomTextFieldWithIconState();
}

class _CustomTextFieldWithIconState extends State<CustomTextFieldWithIcon> {
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

class TextInputCard extends StatefulWidget {
  const TextInputCard({
    Key? key,
    required this.label,
    required this.onChanged,
    this.value,
    this.autofocus = true,
  }) : super(key: key);

  final String label;
  final Function(String) onChanged;
  final String? value;
  final bool autofocus;

  @override
  State<TextInputCard> createState() => _TextInputCardState();
}

class _TextInputCardState extends State<TextInputCard> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldContainer(
      controller: _controller,
      label: widget.label,
      child: TextField(
        controller: _controller,
        onChanged: (value) => widget.onChanged(value),
        cursorColor: Theme.of(context).hintColor,
        autofocus: widget.autofocus,
        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 17),
        decoration: InputDecoration(
          hintText: widget.label,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(0),
        ),
      ),
    );
  }
}

class MultilineTextInputCard extends StatefulWidget {
  const MultilineTextInputCard({
    Key? key,
    required this.label,
    required this.onChanged,
    this.elevation,
    this.value,
    this.autofocus = true,
    this.enabled = true,
  }) : super(key: key);

  final String label;
  final Function(String) onChanged;
  final double? elevation;
  final String? value;
  final bool autofocus;
  final bool enabled;

  @override
  State<MultilineTextInputCard> createState() => _MultilineTextInputCard();
}

class _MultilineTextInputCard extends State<MultilineTextInputCard> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldContainer(
      controller: _controller,
      elevation: widget.elevation,
      label: widget.label,
      child: TextField(
        enabled: widget.enabled,
        controller: _controller,
        onChanged: (value) => widget.onChanged(value),
        cursorColor: Theme.of(context).hintColor,
        autofocus: widget.autofocus,
        style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 17),
        minLines: 4,
        maxLines: 7,
        decoration: InputDecoration(
          hintText: widget.label,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}

class CustomTextFieldContainer extends StatelessWidget {
  const CustomTextFieldContainer({
    Key? key,
    required this.label,
    this.elevation,
    required TextEditingController controller,
    required TextField child,
  })  : controller = controller,
        child = child,
        super(key: key);

  final double? elevation;
  final String label;
  final TextEditingController controller;
  final TextField child;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.all(0),
      elevation: elevation,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
