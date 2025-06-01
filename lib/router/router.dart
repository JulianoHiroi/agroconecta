import 'package:agroconecta/pages.dart';
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
    }

    _unknownPath = uri;
    return AppRoute.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoute configuration) {
    if (configuration.isAbout) {
      return _getRouteInformation(configuration.pageName!.name);
    }

    if (configuration.isUnknown) {
      return RouteInformation(location: _unknownPath?.toString() ?? "/404");
    }

    if (configuration.isContact) {
      return _getRouteInformation(configuration.pageName!.name);
    }

    if (configuration.isServices) {
      return _getRouteInformation(configuration.pageName!.name);
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

    return AppRoute.unknown();
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    if (configuration.isUnknown) {
      _updateRoute(page: null, isUnknown: true);
    }

    if (configuration.isAbout) {
      _updateRoute(page: PageName.about);
    }

    if (configuration.isContact) {
      _updateRoute(page: PageName.contact);
    }

    if (configuration.isServices) {
      _updateRoute(page: PageName.services);
    }

    if (configuration.isHome) {
      _updateRoute(page: PageName.home);
    }
  }

  void _updateRoute({PageName? page, bool isUnknown = false}) {
    notifier.changePage(page: page, unknown: isUnknown);
  }
}

class PageNotifier extends ChangeNotifier {
  PageName _pageName = PageName.home;
  bool _isUnknown = false;

  PageName get pageName => _pageName;
  bool get isUnknown => _isUnknown;

  void changePage({PageName? page, bool unknown = false}) {
    if (unknown) {
      _isUnknown = true;
      _pageName = PageName.home; // Default to home when unknown
    } else {
      _isUnknown = false;
      _pageName = page ?? PageName.home;
    }
    notifyListeners();
  }
}
