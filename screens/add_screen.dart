import 'package:flutter/material.dart';
import '../models/appliance.dart';

class AddApplianceScreen extends StatefulWidget {
  @override
  _AddApplianceScreenState createState() => _AddApplianceScreenState();
}

class _AddApplianceScreenState extends State<AddApplianceScreen> {
  final nameController = TextEditingController();
  final powerController = TextEditingController();

  void _salvar() {
    final name = nameController.text;
    final power = double.tryParse(powerController.text);

    if (name.isNotEmpty && power != null) {
      final novo = Appliance(name: name, power: power);
      Navigator.pop(context, novo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Eletrodoméstico')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: powerController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Potência (W)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }
}
