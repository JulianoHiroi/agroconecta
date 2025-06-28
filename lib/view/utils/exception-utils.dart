import 'package:agroconecta/core/exceptions/exceptions.dart';
import 'package:flutter/material.dart';

Future<void> handleAsync({
  required BuildContext context,
  required Future<void> Function() operation,
}) async {
  try {
    await operation();
  } on AppException catch (e) {
    // erro customizado tratado
    print(e);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(e.message)));
  } catch (e) {
    print(e);
    // erro inesperado
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Erro desconhecido.')));
  }
}
