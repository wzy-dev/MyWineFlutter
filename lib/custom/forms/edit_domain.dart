import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class EditDomain extends StatelessWidget {
  const EditDomain({Key? key, this.domain}) : super(key: key);

  final Domain? domain;

  void _addAction({
    required BuildContext context,
    required String name,
  }) {
    Domain domain = InitializerModel.initDomain(name: name);
    domain.enabled = true;
    MyActions.addDomain(
      context: context,
      domain: domain,
    ).then((value) => Navigator.of(context).pop(name));
  }

  void _editAction({
    required BuildContext context,
    required String name,
  }) {
    Domain editedDomain = domain!;
    editedDomain.name = name;

    MyActions.updateDomain(
      context: context,
      domain: domain,
    ).then((value) => Navigator.of(context).pop(name));
  }

  @override
  Widget build(BuildContext context) {
    return DomainForm(
      submitAction: domain == null ? _addAction : _editAction,
      domain: this.domain,
    );
  }
}
