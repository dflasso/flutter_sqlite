import 'package:app_persitencia_flutter/src/models/basic_model.dart';
import 'package:app_persitencia_flutter/src/providers/db_provaider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  String _text = '';
  String _num = '';
  String _date = '';
  bool isChecked = false;
  List<BasicModel> registers = [];

  final TextEditingController _inputFieldDateController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter persistencia'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          children: _showRegisters(),
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
      onChanged: (value) {
        _text = value;
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
      onChanged: (value) {
        _num = value;
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
        _date = picked.toString();
        _inputFieldDateController.text = _date;
      });
    }
  }

  // ignore: non_constant_identifier_names
  Widget _ButtonSubmit() {
    return ElevatedButton(
      style: style,
      onPressed: () async {
        int id = await DBProvider.db.newRegister(BasicModel(
            paramText: _text,
            paramNum: double.parse(_num),
            paramBool: isChecked,
            paramDate: _date));

        setState(() {
          registers.add(BasicModel(
              id: id,
              paramText: _text,
              paramNum: double.parse(_num),
              paramBool: isChecked,
              paramDate: _date));
        });
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
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            })
      ],
    );
  }

  List<Widget> _showRegisters() {
    List<Widget> wids = <Widget>[
      _ParamTextInput(),
      const Divider(),
      _ParamNumberInput(),
      const Divider(),
      _ParamDateInput(),
      const Divider(),
      _CheckBoxCustom(),
      const Divider(),
      _ButtonSubmit(),
      const Divider(),
      const Divider(),
      const Divider(),
      const Text('Registros')
    ];

    if (registers.isNotEmpty) {
      wids.addAll(registers
          .map(
            (item) => Center(
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.alarm),
                  title: Text(item.paramText),
                  subtitle: Text('Fecha: ${item.paramDate}'),
                ),
              ),
            ),
          )
          .toList());
    } else {
      DBProvider.db.getAllRegisters().then((value) {
        setState(() {
          registers = value;
        });
      });
    }

    return wids;
  }
}
