import 'package:dio/dio.dart';

import 'http_exception.dart';

validateResponse(Response response) {
  if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
    throw HttpException(message: _getMessage(response.statusCode!), code: response.statusCode!);
  }
}

String _getMessage(int statusCode) {
  if (_statusCodeResponses.containsKey(statusCode)) {
    return _statusCodeResponses[statusCode]!;
  }
  return 'Erro desconhecido';
}

final Map<int, String> _statusCodeResponses = {400: 'Bad Request', 401: 'Falha na autenticação', 404: 'Usuário não encontrado'};
