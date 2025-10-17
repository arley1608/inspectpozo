import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// Tabla local (evitamos chocar con tu modelo `Project` de la UI)
class LocalProjects extends Table {
  TextColumn get id => text()(); // PK definida abajo
  TextColumn get name => text()();
  TextColumn get contractNumber => text()();
  TextColumn get client => text()();
  TextColumn get contractor => text()();
  TextColumn get cadastralManager => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [LocalProjects])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Insertar o actualizar por PK (id)
  Future<int> upsertLocalProject(LocalProjectsCompanion p) async {
    return into(localProjects).insertOnConflictUpdate(p);
  }

  /// Eliminar por id
  Future<int> deleteLocalProject(String id) {
    return (delete(localProjects)..where((t) => t.id.equals(id))).go();
  }

  /// Stream para listar (orden por fecha de creación desc)
  Stream<List<LocalProject>> watchLocalProjects() {
    final q = select(localProjects)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return q.watch();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'inspectpozo.db'));
    return NativeDatabase.createInBackground(file);
  });
}
