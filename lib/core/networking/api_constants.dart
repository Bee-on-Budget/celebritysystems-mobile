class ApiConstants {
  static const String apiBaseUrl = "http://10.0.2.2:8080/api/";
  // static const String apiBaseUrl = "http://127.0.0.1:8080/api/";

  // static const String apiBaseUrl = "http://localhost:8080/api/";

  static const String login = "auth/login";
  //wroker end points
  static const String workerTickets =
      "tickets/worker"; //    /api/tickets/worker/{username}

  static const String sendReport =
      "tickets/{ticketId}/worker-report"; //{ticket_id}
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
