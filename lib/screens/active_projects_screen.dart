import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/project.dart';
import '../state/projects_provider.dart'; // projectsStreamProvider & projectsRepoProvider

class ActiveProjectsScreen extends ConsumerWidget {
  const ActiveProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProjects = ref.watch(projectsStreamProvider);

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
          'Proyectos activos',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: asyncProjects.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Error al cargar proyectos: $e'),
          ),
        ),
        data: (projects) {
          if (projects.isEmpty) return const _EmptyState();
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: projects.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) => _ProjectCard(
              project: projects[i],
              parentContext: context, // <<--- contexto estable del Scaffold
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 72, color: Colors.blueGrey),
            const SizedBox(height: 12),
            Text(
              'No hay proyectos activos',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Crea un nuevo proyecto desde el botón en la pantalla principal.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends ConsumerWidget {
  final Project project;
  final BuildContext parentContext; // <<--- contexto superior y estable
  const _ProjectCard({required this.project, required this.parentContext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(projectsRepoProvider);

    Future<void> _confirmDelete() async {
      final ok = await showDialog<bool>(
        context: parentContext, // usar SIEMPRE el contexto estable
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Eliminar proyecto'),
          content: Text('¿Seguro que quieres eliminar "${project.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade600,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );

      if (ok != true) return;

      try {
        await repo.deleteProject(project.id);

        // ✅ Mensaje emergente de éxito usando parentContext (no se desmonta)
        await showDialog<void>(
          context: parentContext,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Proyecto eliminado'),
            content: const Text('El proyecto se eliminó correctamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      } catch (e) {
        await showDialog<void>(
          context: parentContext,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Error al eliminar'),
            content: const Text(
              'No se pudo eliminar el proyecto. Intenta nuevamente.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      }
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              project.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'ID: ${project.id}',
              style: TextStyle(color: Colors.blueGrey.shade700),
            ),
            const Divider(height: 16),

            // Datos
            _row('N° de contrato', project.contractNumber),
            _row('Contratante', project.client),
            _row('Contratista', project.contractor),
            _row('Encargado catastro', project.cadastralManager),

            const SizedBox(height: 12),

            // Botones de acción
            Row(
              children: [
                // Gestionar (azul)
                FilledButton.icon(
                  onPressed: () {
                    // TODO: implementar gestión del proyecto
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Gestionar'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Eliminar (rojo)
                OutlinedButton.icon(
                  onPressed: _confirmDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Eliminar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade700, width: 1.2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
