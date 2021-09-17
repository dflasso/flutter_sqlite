import 'package:app_persitencia_flutter/src/models/basic_model.dart';
import 'package:app_persitencia_flutter/src/pages/edit_data.dart';
import 'package:app_persitencia_flutter/src/providers/db_provaider.dart';
import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  const DataCard({Key? key, this.model}) : super(key: key);

  final BasicModel? model;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.alarm),
              title: Text(model!.paramText),
              subtitle: Text('Fecha: ${model!.paramDate}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      _showMyDialog(context);
                    },
                    child: const Text('Eliminar')),
                const SizedBox(width: 8),
                TextButton(
                    onPressed: () {
                      final route = MaterialPageRoute(
                          builder: (context) => EditDataPage(model!));
                      Navigator.push(context, route);
                    },
                    child: const Text('Actualizar')),
                const SizedBox(width: 8)
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Eliminar item'),
        content: const Text('¿Esta  seguro de eliminarlo?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              DBProvider.db.deleteModel(model!);
              Navigator.pop(context, 'OK');
            },
            child: const Text('Si'),
          ),
        ],
      ),
    );
  }
}
