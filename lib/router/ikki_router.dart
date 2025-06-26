enum IkkiRouter {
  splash(path: "/splash"),
  authDevice(path: "/auth-device"),

  userSelect(path: "/user-select"),

  // Home
  home(path: "/home"),
  history(path: "/history");

  const IkkiRouter({required this.path});
  final String path;
}
