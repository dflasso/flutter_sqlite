import 'package:app_persitencia_flutter/src/models/basic_model.dart';
import 'package:app_persitencia_flutter/src/providers/db_provaider.dart';
import 'package:flutter/material.dart';

class EditDataPage extends StatefulWidget {
  BasicModel _model;

  EditDataPage(this._model);

  @override
  _EditDataPageState createState() => _EditDataPageState(model: _model);
}

class _EditDataPageState extends State<EditDataPage> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  BasicModel? _model;

  final TextEditingController _inputFieldDateController =
      TextEditingController();
  final TextEditingController _inputFieldNumController =
      TextEditingController();
  final TextEditingController _inputFieldTextController =
      TextEditingController();

  _EditDataPageState({required model}) {
    this._model = model;
    print(_model!.paramText);
    if (_model != null) {
      _inputFieldDateController.text = _model!.paramDate;
      _inputFieldNumController.text = _model!.paramNum.toString();
      _inputFieldTextController.text = _model!.paramText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter persistencia'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          children: <Widget>[
            _ParamTextInput(),
            const Divider(),
            _ParamNumberInput(),
            const Divider(),
            _ParamDateInput(),
            const Divider(),
            _CheckBoxCustom(),
            const Divider(),
            _ButtonSubmit()
          ],
        ));
  }

  // ignore: non_constant_identifier_names
  Widget _ParamTextInput() {
    return TextField(
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: 'Ingrese el dato',
        labelText: 'Marca Bicicleta',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      controller: _inputFieldTextController,
      onChanged: (value) {
        _model!.paramText = value;
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget _ParamNumberInput() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Ingrese el dato',
        labelText: 'Precio Bicicleta',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      controller: _inputFieldNumController,
      onChanged: (value) {
        _model!.paramNum = double.parse(value);
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget _ParamDateInput() {
    return TextField(
      controller: _inputFieldDateController,
      decoration: InputDecoration(
        hintText: 'Ingrese la fecha',
        labelText: 'Fecha Creación Bicicleta',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _selectDate(context);
      },
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime.now());

    if (picked != null) {
      setState(() {
        _model!.paramDate = picked.toString();
        _inputFieldDateController.text = _model!.paramDate;
      });
    }
  }

  // ignore: non_constant_identifier_names
  Widget _ButtonSubmit() {
    return ElevatedButton(
      style: style,
      onPressed: () async {
        DBProvider.db.updateModel(_model!);
        Navigator.pop(context);
      },
      child: const Text('Guardar'),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _CheckBoxCustom() {
    return Row(
      children: <Widget>[
        const Text('Bicicleta Nueva ?'),
        Checkbox(
            value: _model!.paramBool,
            onChanged: (bool? value) {
              setState(() {
                _model!.paramBool = value!;
              });
            })
      ],
    );
  }
}
