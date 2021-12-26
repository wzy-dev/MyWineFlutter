import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class CountryForm extends StatefulWidget {
  const CountryForm({
    Key? key,
    required this.submitAction,
    this.country,
  }) : super(key: key);

  final Function({
    required BuildContext context,
    required String name,
  }) submitAction;
  final Country? country;

  @override
  State<CountryForm> createState() => _CountryFormState();
}

class _CountryFormState extends State<CountryForm> {
  late String _name;

  @override
  void initState() {
    _name = widget.country?.name ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: MainContainer(
        title: Text("Ajouter un pays"),
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                children: [
                  TextInputCard(
                    label: "Nom du pays",
                    value: _name,
                    onChanged: (value) => setState(() => _name = value),
                  ),
                  SizedBox(height: 60),
                ],
              ),
              Positioned(
                bottom: 30,
                right: 30,
                child: CustomElevatedButton(
                  icon: Icon(Icons.save_outlined),
                  title: "Ajouter",
                  disabled: !_isComplete(),
                  dense: true,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPress: () =>
                      widget.submitAction(context: context, name: _name),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isComplete() {
    List<String> errors = [];
    if (_name.length == 0) {
      errors.add("empty _name");
    }
    if (errors.length > 0) return false;
    return true;
  }
}
