import 'package:findersedge/services/exceptions/exception_service.dart';
import 'package:findersedge/services/helpers/service_helper.dart';

class ServiceErrorHandler {
  static void handleError(error) {
    hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      ServiceHelper.showErroDialog(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      ServiceHelper.showErroDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      ServiceHelper.showErroDialog(description: 'Oops! It took longer to respond the api, call the developer.');
    }
  }

  static void showLoading([String? message]) {
    ServiceHelper.showLoading(message);
  }

  static void hideLoading() {
    ServiceHelper.hideLoading();
  }
}
