import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/project.dart';

/// Repositorio para CRUD de proyectos en Firestore bajo:
/// users/{uid}/projects/{projectId}
class ProjectsRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  ProjectsRepository({FirebaseAuth? auth, FirebaseFirestore? db})
    : _auth = auth ?? FirebaseAuth.instance,
      _db = db ?? FirebaseFirestore.instance;

  /// UID del usuario autenticado (requerido para el path)
  String get _uid {
    final u = _auth.currentUser;
    if (u == null) {
      throw StateError('No hay usuario autenticado');
    }
    return u.uid;
  }

  /// Colección de proyectos del usuario actual
  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('users').doc(_uid).collection('projects');

  /// Crea o sobrescribe un proyecto (idempotente si usas el mismo id)
  Future<void> addProject(Project p) async {
    await _col.doc(p.id).set({
      'id': p.id,
      'name': p.name,
      'contractNumber': p.contractNumber,
      'client': p.client,
      'contractor': p.contractor,
      'cadastralManager': p.cadastralManager,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Actualiza campos de un proyecto existente
  Future<void> updateProject(Project p) async {
    await _col.doc(p.id).update({
      'name': p.name,
      'contractNumber': p.contractNumber,
      'client': p.client,
      'contractor': p.contractor,
      'cadastralManager': p.cadastralManager,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Elimina un proyecto por id
  Future<void> deleteProject(String id) async {
    await _col.doc(id).delete();
  }

  /// Obtiene un proyecto una sola vez
  Future<Project?> getProject(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    final m = doc.data()!;
    return Project(
      id: m['id'] as String? ?? doc.id,
      name: m['name'] as String? ?? '',
      contractNumber: m['contractNumber'] as String? ?? '',
      client: m['client'] as String? ?? '',
      contractor: m['contractor'] as String? ?? '',
      cadastralManager: m['cadastralManager'] as String? ?? '',
    );
  }

  /// Stream en tiempo real de los proyectos del usuario (ordenados por fecha)
  Stream<List<Project>> streamProjects() {
    return _col
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) {
            final m = d.data();
            return Project(
              id: m['id'] as String? ?? d.id,
              name: m['name'] as String? ?? '',
              contractNumber: m['contractNumber'] as String? ?? '',
              client: m['client'] as String? ?? '',
              contractor: m['contractor'] as String? ?? '',
              cadastralManager: m['cadastralManager'] as String? ?? '',
            );
          }).toList(),
        );
  }
}
