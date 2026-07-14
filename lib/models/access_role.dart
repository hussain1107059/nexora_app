class ModulePermission {
  final String moduleName;
  final String access;

  const ModulePermission({
    required this.moduleName,
    required this.access,
  });
}

class AccessRole {
  final String roleName;
  final String description;
  final String status;
  final List<ModulePermission> permissions;

  const AccessRole({
    required this.roleName,
    required this.description,
    required this.status,
    required this.permissions,
  });
}
