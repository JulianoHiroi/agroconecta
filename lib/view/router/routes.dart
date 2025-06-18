class AppRoute {
  final PageName? pageName;
  final bool isUnknown;
  final String? itemId;

  AppRoute._({this.pageName, this.isUnknown = false, this.itemId});

  factory AppRoute.home() => AppRoute._(pageName: PageName.home);
  factory AppRoute.about() => AppRoute._(pageName: PageName.about);
  factory AppRoute.contact() => AppRoute._(pageName: PageName.contact);
  factory AppRoute.services() => AppRoute._(pageName: PageName.services);
  factory AppRoute.itens() => AppRoute._(pageName: PageName.itens);
  factory AppRoute.itemDetails(String id) =>
      AppRoute._(pageName: PageName.itens, itemId: id);

  factory AppRoute.unknown() => AppRoute._(isUnknown: true);

  bool get isHome => pageName == PageName.home;
  bool get isAbout => pageName == PageName.about;
  bool get isContact => pageName == PageName.contact;
  bool get isServices => pageName == PageName.services;
  bool get isItens => pageName == PageName.itens && itemId == null;
  bool get isItemDetails => pageName == PageName.itens && itemId != null;
}

enum PageName { home, contact, about, services, itens }
