import 'package:flutter/material.dart';
import '../models/appliance.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Appliance> _appliances = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _powerController = TextEditingController();

  void _addAppliance() {
    final name = _nameController.text.trim();
    final powerText = _powerController.text.trim();

    if (name.isEmpty || powerText.isEmpty) {
      _showError('Preencha todos os campos.');
      return;
    }

    final power = double.tryParse(powerText);
    if (power == null) {
      _showError('Potência deve ser um número.');
      return;
    }

    setState(() {
      _appliances.add(Appliance(name: name, power: power));
      _nameController.clear();
      _powerController.clear();
    });
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  void _goToSimulate() {
    if (_appliances.isEmpty) {
      _showError('Cadastre pelo menos um eletrodoméstico.');
      return;
    }
    Navigator.pushNamed(
      context,
      '/simulate',
      arguments: _appliances,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartEnergy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Eletrodoméstico',
              ),
            ),
            TextField(
              controller: _powerController,
              decoration: const InputDecoration(
                labelText: 'Potência (W)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addAppliance,
              child: const Text('Adicionar'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Eletrodomésticos Cadastrados:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _appliances.length,
                itemBuilder: (context, index) {
                  final appliance = _appliances[index];
                  return ListTile(
                    title: Text(appliance.name),
                    subtitle: Text('${appliance.power} W'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _goToSimulate,
              child: const Text('Simular Custo'),
            ),
          ],
        ),
      ),
    );
  }
}
