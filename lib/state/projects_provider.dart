import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';

class ProjectsNotifier extends StateNotifier<List<Project>> {
  ProjectsNotifier() : super(const []);

  void add(Project p) => state = [p, ...state];
  void clear() => state = const [];
}

final projectsProvider = StateNotifierProvider<ProjectsNotifier, List<Project>>(
  (ref) {
    return ProjectsNotifier();
  },
);
