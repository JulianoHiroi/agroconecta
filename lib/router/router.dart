import 'package:agroconecta/pages.dart';
import 'package:agroconecta/pages/PageItens.dart';
import 'package:agroconecta/router/routes.dart';
import 'package:flutter/material.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRoute> {
  Uri? _unknownPath;

  @override
  Future<AppRoute> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return AppRoute.home();
    }

    if (uri.pathSegments.length > 1) {
      _unknownPath = routeInformation.uri;
      return AppRoute.unknown();
    }

    if (uri.pathSegments.length == 1) {
      if (uri.pathSegments.first == PageName.about.name) {
        return AppRoute.about();
      }

      if (uri.pathSegments.first == PageName.contact.name) {
        return AppRoute.contact();
      }

      if (uri.pathSegments.first == PageName.services.name) {
        return AppRoute.services();
      }
      if (uri.pathSegments.first == PageName.itens.name) {
        return AppRoute.itens();
      }
    }
    // rota dinâmica: /itens/:id
    if (uri.pathSegments.length == 2 &&
        uri.pathSegments.first == PageName.itens.name) {
      final id = uri.pathSegments[1];
      return AppRoute.itemDetails(id);
    }

    _unknownPath = uri;
    return AppRoute.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoute configuration) {
    if (configuration.isItemDetails && configuration.itemId != null) {
      return RouteInformation(location: '/itens/${configuration.itemId}');
    }

    if (configuration.isItens) {
      return _getRouteInformation(PageName.itens.name);
    }

    if (configuration.isAbout) return _getRouteInformation(PageName.about.name);
    if (configuration.isContact)
      return _getRouteInformation(PageName.contact.name);
    if (configuration.isServices)
      return _getRouteInformation(PageName.services.name);
    if (configuration.isUnknown) {
      return RouteInformation(location: _unknownPath?.toString() ?? "/404");
    }

    return RouteInformation(location: "/");
  }

  //Get Route Information depending on the PageName passed
  RouteInformation _getRouteInformation(String page) {
    return RouteInformation(location: '/$page');
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  final PageNotifier notifier;

  AppRouterDelegate({required this.notifier}) {
    notifier.addListener(notifyListeners);
  }

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (notifier.isUnknown) const MaterialPage(child: PageNotFound()),
        if (!notifier.isUnknown)
          MaterialPage(child: HomePage(pageNotifier: notifier)),
        if (notifier.pageName == PageName.home)
          MaterialPage(child: HomePage(pageNotifier: notifier)),
        if (notifier.pageName == PageName.about)
          MaterialPage(child: AboutPage(pageNotifier: notifier)),
        if (notifier.pageName == PageName.contact)
          const MaterialPage(child: ContactPage()),
        if (notifier.pageName == PageName.services)
          const MaterialPage(child: ServicesPage()),
        if (notifier.pageName == PageName.itens)
          MaterialPage(child: PageItens(pageNotifier: notifier)),
        if (notifier.pageName == PageName.itens && notifier.itemId != null)
          MaterialPage(child: PageItensDetail(id: notifier.itemId!)),
      ],
      onDidRemovePage: (onPage) {
        if (onPage.name == PageName.home.name) {
          notifier.changePage(page: PageName.home);
        }
      },
    );
  }

  @override
  AppRoute? get currentConfiguration {
    if (notifier.isUnknown) {
      return AppRoute.unknown();
    }

    if (notifier.pageName == PageName.home) {
      return AppRoute.home();
    }

    if (notifier.pageName == PageName.about) {
      return AppRoute.about();
    }

    if (notifier.pageName == PageName.contact) {
      return AppRoute.contact();
    }

    if (notifier.pageName == PageName.services) {
      return AppRoute.services();
    }

    if (notifier.pageName == PageName.itens) {
      return AppRoute.itens();
    }
    if (notifier.pageName == PageName.itens && notifier.itemId != null) {
      return AppRoute.itemDetails(notifier.itemId!);
    }

    return AppRoute.unknown();
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    if (configuration.isUnknown) {
      _updateRoute(isUnknown: true);
    } else if (configuration.isItemDetails) {
      _updateRoute(page: PageName.itens, itemId: configuration.itemId);
    } else {
      _updateRoute(page: configuration.pageName);
    }
  }

  void _updateRoute({PageName? page, bool isUnknown = false, String? itemId}) {
    notifier.changePage(page: page, unknown: isUnknown, itemId: itemId);
  }
}

class PageNotifier extends ChangeNotifier {
  PageName _pageName = PageName.home;
  bool _isUnknown = false;
  String? _itemId;

  PageName get pageName => _pageName;
  bool get isUnknown => _isUnknown;
  String? get itemId => _itemId;

  void changePage({PageName? page, bool unknown = false, String? itemId}) {
    if (unknown) {
      _isUnknown = true;
      _pageName = PageName.home;
      _itemId = null;
    } else {
      _isUnknown = false;
      _pageName = page ?? PageName.home;
      _itemId = itemId;
    }
    notifyListeners();
  }
}
