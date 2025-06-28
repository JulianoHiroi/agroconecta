abstract class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class BadRequestException extends AppException {
  BadRequestException([super.message = 'Requisição inválida.']);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Não autorizado.']);
}

class NotFoundException extends AppException {
  NotFoundException([super.message = 'Recurso não encontrado.']);
}

class ServerErrorException extends AppException {
  ServerErrorException([super.message = 'Erro interno no servidor.']);
}

class ForbiddenException extends AppException {
  ForbiddenException([super.message = 'Acesso proibido.']);
}

class TimeoutException extends AppException {
  TimeoutException([super.message = 'Tempo de resposta excedido.']);
}

class UnexpectedException extends AppException {
  UnexpectedException([super.message = 'Erro inesperado.']);
}
