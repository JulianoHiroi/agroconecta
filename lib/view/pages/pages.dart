import 'package:agroconecta/view/router/router.dart';
import 'package:agroconecta/view/router/routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final PageNotifier pageNotifier;

  const HomePage({required this.pageNotifier, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to AgroConecta!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.pageNotifier.changePage(page: PageName.about);
              },
              child: Text('About'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.pageNotifier.changePage(page: PageName.contact);
              },
              child: Text('Contact'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.pageNotifier.changePage(page: PageName.services);
              },
              child: Text('Services'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.pageNotifier.changePage(page: PageName.itens);
              },
              child: Text('Items'),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  final PageNotifier pageNotifier;

  const AboutPage({super.key, required this.pageNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('About AgroConecta'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Home'),
            ),
            ElevatedButton(
              onPressed: () {
                pageNotifier.changePage(page: PageName.contact);
              },
              child: Text('Go to Contact'),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Contact Us'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Services')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Our Services'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('404 - Page Not Found'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
