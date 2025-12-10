import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/theme.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  // Contrôleurs
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedType = "Appartement";
  final List<String> _propertyTypes = [
    "Appartement",
    "Maison / Villa",
    "Studio",
    "Magasin / Bureau",
  ];

  // Gestion des commodités (Amenities)
  final Map<String, IconData> _amenities = {
    "Wifi": Icons.wifi,
    "Parking": Icons.local_parking,
    "Clim": FontAwesomeIcons.temperatureArrowUp,
    "Gardien": Icons.security,
    "Piscine": Icons.pool,
    "Meublé": Icons.chair,
    "Groupe Élec.": Icons.electric_bolt,
    "Eau Forage": Icons.water_drop,
  };

  final List<String> _selectedAmenities = [];

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
          "Nouveau Bien",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PHOTOS DU BIEN (Placeholder interactif)
            _buildSectionTitle("Photos"),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.3),
                  style: BorderStyle.solid,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppTheme.brickOrange.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_a_photo_rounded,
                      size: 30,
                      color: AppTheme.brickOrange,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Ajouter la photo principale",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Format conseillé : Paysage",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            // Miniatures (Simulation d'ajout)
            Row(
              children: [
                _buildThumbAdd(),
                const SizedBox(width: 10),
                _buildThumbAdd(),
                const SizedBox(width: 10),
                _buildThumbAdd(),
              ],
            ),

            const SizedBox(height: 30),

            // 2. INFORMATIONS GÉNÉRALES
            _buildSectionTitle("Détails"),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildDropdownType(),
                  const SizedBox(height: 15),
                  _buildInputField(
                    "Nom du bien (ex: Rés. Palmiers A12)",
                    Icons.label_outline,
                    _titleController,
                  ),
                  const SizedBox(height: 15),
                  _buildInputField(
                    "Adresse / Quartier",
                    Icons.location_on_outlined,
                    _addressController,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          "Loyer Mensuel",
                          Icons.monetization_on_outlined,
                          _priceController,
                          isNumber: true,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text(
                          "FCFA / mois",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 3. COMMODITÉS (Chips Séléctionnables)
            _buildSectionTitle("Équipements & Atouts"),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _amenities.entries.map((entry) {
                final isSelected = _selectedAmenities.contains(entry.key);
                return FilterChip(
                  label: Text(entry.key),
                  avatar: isSelected
                      ? null
                      : Icon(entry.value, size: 16, color: Colors.grey),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedAmenities.add(entry.key);
                      } else {
                        _selectedAmenities.remove(entry.key);
                      }
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: AppTheme.darkBlue,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade300,
                    ),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 8,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // BOUTON CRÉER
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Bien ajouté au portefeuille ! 🏠"),
                      backgroundColor: AppTheme.successGreen,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkBlue,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  "CRÉER LE BIEN",
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
    );
  }

  // --- WIDGETS HELPERS ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildThumbAdd() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Icon(Icons.add, color: Colors.grey),
    );
  }

  Widget _buildDropdownType() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedType,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.darkBlue),
          items: _propertyTypes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(
                    _getTypeIcon(value),
                    color: AppTheme.brickOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (newValue) => setState(() => _selectedType = newValue!),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    if (type.contains("Appartement")) return FontAwesomeIcons.building;
    if (type.contains("Maison")) return FontAwesomeIcons.houseChimney;
    if (type.contains("Studio")) return FontAwesomeIcons.doorOpen;
    return FontAwesomeIcons.briefcase;
  }

  Widget _buildInputField(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
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
      ),
    );
  }
}
