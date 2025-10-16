class Project {
  final String id;
  final String name;
  final String contractNumber;
  final String client; // Contratante
  final String contractor; // Contratista
  final String cadastralManager; // Encargado catastro

  Project({
    required this.id,
    required this.name,
    required this.contractNumber,
    required this.client,
    required this.contractor,
    required this.cadastralManager,
  });
}
