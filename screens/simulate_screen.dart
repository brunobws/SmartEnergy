import 'package:flutter/material.dart';
import '../models/appliance.dart';

class SimulateScreen extends StatefulWidget {
  final List<Appliance> appliances;

  const SimulateScreen({super.key, required this.appliances});

  @override
  _SimulateScreenState createState() => _SimulateScreenState();
}

class _SimulateScreenState extends State<SimulateScreen> {
  Appliance? _selectedAppliance;
  final TextEditingController _hoursPerDayController = TextEditingController();
  final TextEditingController _daysPerMonthController = TextEditingController();
  final TextEditingController _tariffController = TextEditingController();

  double? _costResult;

  void _calculateCost() {
    if (_selectedAppliance == null) {
      _showError('Selecione um eletrodoméstico.');
      return;
    }

    final hoursPerDay = double.tryParse(_hoursPerDayController.text);
    final daysPerMonth = int.tryParse(_daysPerMonthController.text);
    final tariff = double.tryParse(_tariffController.text);

    if (hoursPerDay == null || daysPerMonth == null || tariff == null) {
      _showError('Preencha todos os campos corretamente.');
      return;
    }

    final energyConsumption = _selectedAppliance!.power / 1000 * hoursPerDay * daysPerMonth; // kWh
    final cost = energyConsumption * tariff;

    setState(() {
      _costResult = cost;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simular Custo'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dropdown estilizado
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Eletrodoméstico',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Appliance>(
                    hint: const Text('Selecione o eletrodoméstico'),
                    value: _selectedAppliance,
                    isExpanded: true,
                    onChanged: (Appliance? newValue) {
                      setState(() {
                        _selectedAppliance = newValue;
                      });
                    },
                    items: widget.appliances.map((appliance) {
                      return DropdownMenuItem(
                        value: appliance,
                        child: Text('${appliance.name} (${appliance.power} W)'),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Inputs com estilo moderno
              _buildNumberField(
                controller: _hoursPerDayController,
                label: 'Horas por dia',
                context: context,
              ),
              const SizedBox(height: 16),
              _buildNumberField(
                controller: _daysPerMonthController,
                label: 'Dias por mês',
                context: context,
                isInt: true,
              ),
              const SizedBox(height: 16),
              _buildNumberField(
                controller: _tariffController,
                label: 'Tarifa (R\$ por kWh)',
                context: context,
              ),

              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: _calculateCost,
                icon: const Icon(Icons.calculate),
                label: const Text('Calcular Custo'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                ),
              ),

              const SizedBox(height: 32),

              if (_costResult != null)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.secondary, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Custo estimado',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'R\$ ${_costResult!.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required BuildContext context,
    bool isInt = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: !isInt, signed: false),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}
