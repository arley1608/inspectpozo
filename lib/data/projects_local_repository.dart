import 'package:drift/drift.dart' as d;
import '../local/app_database.dart';
import '../models/project.dart';

/// Repositorio que traduce entre tu modelo de UI `Project` y la BD local.
class ProjectsLocalRepository {
  final AppDatabase db;
  ProjectsLocalRepository(this.db);

  Future<void> addOrUpdate(Project p) async {
    await db.upsertLocalProject(
      LocalProjectsCompanion(
        id: d.Value(p.id),
        name: d.Value(p.name),
        contractNumber: d.Value(p.contractNumber),
        client: d.Value(p.client),
        contractor: d.Value(p.contractor),
        cadastralManager: d.Value(p.cadastralManager),
        updatedAt: d.Value(DateTime.now()),
      ),
    );
  }

  Future<void> delete(String id) => db.deleteLocalProject(id);

  Stream<List<Project>> watchAll() {
    return db.watchLocalProjects().map((rows) {
      return rows
          .map(
            (r) => Project(
              id: r.id,
              name: r.name,
              contractNumber: r.contractNumber,
              client: r.client,
              contractor: r.contractor,
              cadastralManager: r.cadastralManager,
            ),
          )
          .toList();
    });
  }
}
