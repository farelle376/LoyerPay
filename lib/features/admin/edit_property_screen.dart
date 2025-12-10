import 'dart:io'; // Pour gérer les fichiers locaux

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart'; // Pour ouvrir la galerie

import '../../config/theme.dart';

class EditPropertyScreen extends StatefulWidget {
  final Map<String, dynamic> propertyData;

  const EditPropertyScreen({super.key, required this.propertyData});

  @override
  State<EditPropertyScreen> createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  // Contrôleurs
  late TextEditingController _titleController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;

  String _selectedType = "Appartement";
  final List<String> _propertyTypes = [
    "Appartement",
    "Maison / Villa",
    "Studio",
    "Magasin / Bureau",
  ];

  // Gestion des images
  File? _selectedImage; // La nouvelle image (si choisie)
  final ImagePicker _picker = ImagePicker();

  // Simulation des commodités
  final List<String> _selectedAmenities = ["Wifi", "Clim", "Gardien"];
  final Map<String, IconData> _allAmenities = {
    "Wifi": Icons.wifi,
    "Parking": Icons.local_parking,
    "Clim": FontAwesomeIcons.temperatureArrowUp,
    "Gardien": Icons.security,
    "Piscine": Icons.pool,
    "Meublé": Icons.chair,
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.propertyData['name']);
    _addressController = TextEditingController(
      text: widget.propertyData['address'],
    );
    _priceController = TextEditingController(text: "150000");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // --- FONCTION POUR CHOISIR UNE PHOTO ---
  Future<void> _pickImage() async {
    // Ouvre la galerie du téléphone
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path); // On stocke la nouvelle image
      });
    }
  }

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
          "Modifier le Bien",
          style: TextStyle(
            color: AppTheme.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text(
              "SAUVER",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.brickOrange,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PHOTO (DYNAMIQUE)
            _buildSectionTitle("Visuel Principal"),
            GestureDetector(
              onTap: _pickImage, // Clic sur l'image = Ouvrir galerie
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade200,
                      image: DecorationImage(
                        // LOGIQUE INTELLIGENTE :
                        // Si une nouvelle image est choisie (_selectedImage), on l'affiche.
                        // Sinon, on affiche l'ancienne (URL du web).
                        image: _selectedImage != null
                            ? FileImage(_selectedImage!) as ImageProvider
                            : NetworkImage(widget.propertyData['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Bouton Caméra superposé
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.photo_library,
                            size: 16,
                            color: AppTheme.darkBlue,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Changer photo",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 2. FORMULAIRE (Inchangé)
            _buildSectionTitle("Informations"),
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
                    "Nom du bien",
                    Icons.label_outline,
                    _titleController,
                  ),
                  const SizedBox(height: 15),
                  _buildInputField(
                    "Adresse",
                    Icons.location_on_outlined,
                    _addressController,
                  ),
                  const SizedBox(height: 15),
                  _buildInputField(
                    "Loyer (FCFA)",
                    Icons.monetization_on_outlined,
                    _priceController,
                    isNumber: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 3. COMMODITÉS
            _buildSectionTitle("Équipements"),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _allAmenities.entries.map((entry) {
                final isSelected = _selectedAmenities.contains(entry.key);
                return FilterChip(
                  label: Text(entry.key),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      val
                          ? _selectedAmenities.add(entry.key)
                          : _selectedAmenities.remove(entry.key);
                    });
                  },
                  selectedColor: AppTheme.darkBlue.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.darkBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.darkBlue : Colors.black,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // ZONE DE DANGER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  const Text(
                    "Zone de Danger",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_forever),
                    label: const Text("SUPPRIMER CE BIEN"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Modifications enregistrées ! ✅"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    IconData icon,
    TextEditingController ctrl, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF8F9FD),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdownType() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FD),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedType,
          isExpanded: true,
          items: _propertyTypes
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _selectedType = v!),
        ),
      ),
    );
  }
}
