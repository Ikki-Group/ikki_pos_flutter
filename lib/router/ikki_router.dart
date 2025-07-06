enum IkkiRouter {
  widgetsbook(path: "/widgetsbook"),

  splash(path: "/splash"),
  authDevice(path: "/auth-device"),

  userSelect(path: "/user-select"),

  // Home
  home(path: "/home"),
  history(path: "/history"),

  // Cart
  cartSelection(path: "/cart-selection"),
  cartPayment(path: "/cart-payment")
  //
  ;

  const IkkiRouter({required this.path});
  final String path;
}
