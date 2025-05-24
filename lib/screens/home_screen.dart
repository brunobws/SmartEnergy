import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SmartEnergy',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Eletrodoméstico',
                  prefixIcon: const Icon(Icons.electrical_services),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _powerController,
                decoration: InputDecoration(
                  labelText: 'Potência (W)',
                  prefixIcon: const Icon(Icons.flash_on),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addAppliance,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Eletrodomésticos Cadastrados:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _appliances.isEmpty
                    ? const Center(child: Text('Nenhum item cadastrado ainda.'))
                    : ListView.builder(
                        itemCount: _appliances.length,
                        itemBuilder: (context, index) {
                          final appliance = _appliances[index];
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 2,
                            child: ListTile(
                              leading: const Icon(Icons.kitchen),
                              title: Text(appliance.name),
                              subtitle: Text('${appliance.power} W'),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _goToSimulate,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Simular Custo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: Colors.white, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
