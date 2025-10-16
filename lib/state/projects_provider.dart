import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/projects_repository.dart';
import '../models/project.dart';

/// Proveedor del repositorio Firestore
final projectsRepoProvider = Provider<ProjectsRepository>((ref) {
  return ProjectsRepository();
});

/// Stream de proyectos en tiempo real (opcional para la lista)
final projectsStreamProvider = StreamProvider<List<Project>>((ref) {
  final repo = ref.watch(projectsRepoProvider);
  return repo.streamProjects();
});
