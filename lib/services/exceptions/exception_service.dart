class ExceptionService implements Exception {
  final String? message;
  final String? prefix;
  final String? url;

  ExceptionService([this.message, this.prefix, this.url]);
}

class BadRequestException extends ExceptionService {
  BadRequestException([String? message, String? url]) : super(message, 'Bad Request', url);
}

class FetchDataException extends ExceptionService {
  FetchDataException([String? message, String? url]) : super(message, 'Unable to process', url);
}

class ApiNotRespondingException extends ExceptionService {
  ApiNotRespondingException([String? message, String? url]) : super(message, 'Api not responded in time', url);
}

class UnAuthorizedException extends ExceptionService {
  UnAuthorizedException([String? message, String? url]) : super(message, 'UnAuthorized request', url);
}
