import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/app_database.dart';
import '../data/projects_local_repository.dart';
import '../models/project.dart';

/// BD (singleton simple para toda la app)
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Repositorio local
final projectsLocalRepoProvider = Provider<ProjectsLocalRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProjectsLocalRepository(db);
});

/// Stream de proyectos (local, offline)
final projectsStreamProvider = StreamProvider<List<Project>>((ref) {
  final repo = ref.watch(projectsLocalRepoProvider);
  return repo.watchAll();
});

/// (Opcional) Alias si tenías referencias antiguas
final projectsProvider = projectsStreamProvider;
