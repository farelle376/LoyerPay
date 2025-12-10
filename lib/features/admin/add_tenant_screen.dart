import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../config/theme.dart';

class AddTenantScreen extends StatefulWidget {
  const AddTenantScreen({super.key});

  @override
  State<AddTenantScreen> createState() => _AddTenantScreenState();
}

class _AddTenantScreenState extends State<AddTenantScreen> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();

  // Variables d'état
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedProperty;

  // Liste factice de biens libres
  final List<String> _properties = [
    "Appt A14 - Rés. Palmiers",
    "Villa 03 - Cotonou",
    "Studio B01 - Rés. Cocotiers",
    "Magasin C4 - Marché Dantokpa",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Nouveau Locataire",
          style: TextStyle(
            color: AppTheme.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. SECTION IDENTITÉ
              _buildSectionTitle("Informations Personnelles"),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar Upload
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppTheme.brickOrange,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildInputField(
                      "Nom complet",
                      Icons.person_outline,
                      _nameController,
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      "Téléphone",
                      Icons.phone_outlined,
                      _phoneController,
                      isNumber: true,
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      "Email (Optionnel)",
                      Icons.email_outlined,
                      TextEditingController(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 2. SECTION BAIL & CONTRAT
              _buildSectionTitle("Détails du Bail"),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Sélecteur de Bien
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration(
                        "Bien loué",
                        Icons.home_work_outlined,
                      ),
                      value: _selectedProperty,
                      items: _properties.map((prop) {
                        return DropdownMenuItem(
                          value: prop,
                          child: Text(
                            prop,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedProperty = val),
                    ),
                    const SizedBox(height: 15),

                    _buildInputField(
                      "Montant du Loyer",
                      Icons.money,
                      _amountController,
                      isNumber: true,
                      suffix: "FCFA",
                    ),

                    const SizedBox(height: 15),

                    // Dates (Entrée / Sortie)
                    Row(
                      children: [
                        Expanded(
                          child: _buildDatePicker(
                            "Début Bail",
                            _startDate,
                            (date) => setState(() => _startDate = date),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildDatePicker(
                            "Fin Bail",
                            _endDate,
                            (date) => setState(() => _endDate = date),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 3. UPLOAD CONTRAT
              _buildSectionTitle("Documents"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.darkBlue.withOpacity(0.2),
                    style: BorderStyle.solid,
                  ), // Style pointillé simulé
                ),
                child: Column(
                  children: [
                    const Icon(
                      FontAwesomeIcons.filePdf,
                      size: 40,
                      color: AppTheme.darkBlue,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Téléverser le contrat signé",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "PDF ou Image (Max 5MB)",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // BOUTON ENREGISTRER
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Simulation
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Locataire ajouté avec succès !"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkBlue,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "ENREGISTRER LE LOCATAIRE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS HELPERS ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool isNumber = false,
    String? suffix,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: _inputDecoration(label, icon, suffix: suffix),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    String? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      suffixText: suffix,
      filled: true,
      fillColor: const Color(0xFFF8F9FD),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.darkBlue),
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? selectedDate,
    Function(DateTime) onSelect,
  ) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppTheme.darkBlue,
                  onPrimary: Colors.white,
                  onSurface: AppTheme.darkBlue,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) onSelect(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FD),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedDate == null
                    ? label
                    : DateFormat('dd/MM/yyyy').format(selectedDate),
                style: TextStyle(
                  color: selectedDate == null
                      ? Colors.grey.shade600
                      : Colors.black,
                  fontWeight: selectedDate == null
                      ? FontWeight.normal
                      : FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
