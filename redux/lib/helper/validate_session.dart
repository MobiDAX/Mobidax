import 'package:graphql/client.dart';

bool validateSession(String barongSessionExpires) {
  if (barongSessionExpires != '') {
    return DateTime.now().millisecondsSinceEpoch >=
        int.parse(barongSessionExpires);
  } else {
    return true;
  }
}

bool sessionInvalidException(OperationException exception) {
  if (exception.toString().contains('authz.invalid_session') ||
      exception.toString().contains('authz.client_session_mismatch') ||
      exception.toString().contains('identity.session.not_found')) {
    return true;
  }
  return false;
}
