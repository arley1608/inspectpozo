import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../state/projects_provider.dart';
import '../theme/app_buttons.dart';

class NewProjectScreen extends ConsumerStatefulWidget {
  const NewProjectScreen({super.key});

  @override
  ConsumerState<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends ConsumerState<NewProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _contractNumberCtrl = TextEditingController();
  final _clientCtrl = TextEditingController(); // Contratante
  final _contractorCtrl = TextEditingController(); // Contratista
  final _cadastralManagerCtrl = TextEditingController(); // Encargado catastro
  bool _saving = false;

  @override
  void dispose() {
    _idCtrl.dispose();
    _nameCtrl.dispose();
    _contractNumberCtrl.dispose();
    _clientCtrl.dispose();
    _contractorCtrl.dispose();
    _cadastralManagerCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final p = Project(
      id: _idCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
      contractNumber: _contractNumberCtrl.text.trim(),
      client: _clientCtrl.text.trim(),
      contractor: _contractorCtrl.text.trim(),
      cadastralManager: _cadastralManagerCtrl.text.trim(),
    );
    ref.read(projectsProvider.notifier).add(p);

    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Proyecto creado')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(height: 16);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Nuevo Proyecto',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _field(
                            controller: _idCtrl,
                            label: 'ID del proyecto',
                            icon: Icons.tag,
                          ),
                          spacing,
                          _field(
                            controller: _nameCtrl,
                            label: 'Nombre del proyecto',
                            icon: Icons.business_center,
                          ),
                          spacing,
                          _field(
                            controller: _contractNumberCtrl,
                            label: 'Número de contrato',
                            icon: Icons.confirmation_number,
                            keyboard: TextInputType.number,
                          ),
                          spacing,
                          _field(
                            controller: _clientCtrl,
                            label: 'Contratante',
                            icon: Icons.account_balance,
                          ),
                          spacing,
                          _field(
                            controller: _contractorCtrl,
                            label: 'Contratista',
                            icon: Icons.handshake,
                          ),
                          spacing,
                          _field(
                            controller: _cadastralManagerCtrl,
                            label: 'Nombre encargado catastro',
                            icon: Icons.person,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _saving ? null : _save,
                              icon: _saving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.save_rounded, size: 24),
                              label: const Text('GUARDAR PROYECTO'),
                              style: AppButtons.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'InspectPozo',
                  style: TextStyle(
                    color: Colors.blueGrey.shade500,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 1.5),
        ),
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null,
    );
  }
}
