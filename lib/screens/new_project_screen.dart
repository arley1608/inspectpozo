import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/project.dart';
import '../state/projects_provider.dart'; // projectsLocalRepoProvider

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
  final _clientCtrl = TextEditingController();
  final _contractorCtrl = TextEditingController();
  final _cadastralManagerCtrl = TextEditingController();

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

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: const OutlineInputBorder(),
  );

  Future<void> _showDialog({
    required String title,
    required String message,
    bool success = true,
  }) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
    if (success && mounted) context.pop();
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

    try {
      final repo = ref.read(projectsLocalRepoProvider);
      await repo.addOrUpdate(p);

      if (!mounted) return;
      setState(() => _saving = false);
      await _showDialog(
        title: 'Proyecto creado',
        message: 'El proyecto se guardó correctamente (offline).',
        success: true,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      await _showDialog(
        title: 'Error al guardar',
        message: 'No se pudo crear el proyecto. Intenta nuevamente.',
        success: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Nuevo proyecto',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: _idCtrl,
                      decoration: _dec('ID del proyecto', Icons.tag),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    spacing,
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: _dec(
                        'Nombre del proyecto',
                        Icons.business_center,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    spacing,
                    TextFormField(
                      controller: _contractNumberCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _dec(
                        'Número de contrato',
                        Icons.confirmation_number,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    spacing,
                    TextFormField(
                      controller: _clientCtrl,
                      decoration: _dec('Contratante', Icons.account_balance),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    spacing,
                    TextFormField(
                      controller: _contractorCtrl,
                      decoration: _dec('Contratista', Icons.handshake),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    spacing,
                    TextFormField(
                      controller: _cadastralManagerCtrl,
                      decoration: _dec(
                        'Nombre encargado catastro',
                        Icons.person,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    FilledButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_rounded),
                      label: const Text('Guardar proyecto'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
