import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class AddDomain extends StatefulWidget {
  const AddDomain({Key? key}) : super(key: key);

  @override
  State<AddDomain> createState() => _AddDomainState();
}

class _AddDomainState extends State<AddDomain> {
  String _name = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: MainContainer(
        title: Text("Ajouter un domaine"),
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                children: [
                  TextInputCard(
                    label: "Nom du domaine",
                    value: _name,
                    onChanged: (value) => _name = value,
                  ),
                  SizedBox(height: 60),
                ],
              ),
              Positioned(
                bottom: 30,
                // (MediaQuery.of(context).viewInsets.bottom > 200
                //     ? MediaQuery.of(context).viewInsets.bottom - 30
                //     : 30),
                right: 30,
                child: CustomElevatedButton(
                  icon: Icon(Icons.save_outlined),
                  title: "Ajouter",
                  disabled: !_isComplete(),
                  dense: true,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPress: () {
                    Domain domain = InitializerModel.initDomain(name: _name);
                    domain.enabled = true;
                    MyActions.addDomain(
                      context: context,
                      domain: domain,
                    ).then((value) => Navigator.of(context).pop(_name));
                  },
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
