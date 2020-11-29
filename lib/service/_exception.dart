import 'dart:convert';

import '../util/network_config.dart';

class ServiceException implements Exception {
  GRPCError code;
  String message;
  ServiceException(Map<String, dynamic> data) {
    message = data['message'];
    code = CodeToError[data['code']];
  }
}

Exception checkServiceError(ApiError apiError) {
  try {
    return ServiceException(json.decode(apiError.errorMessage));
  } catch(e) {
    return apiError;
  }
}

enum GRPCError {
  OK,
  CANCELLED,
  UNKNOWN,
  INVALID_ARGUMENT,
  DEADLINE_EXCEEDED,
  NOT_FOUND,
  ALREADY_EXISTS,
  PERMISSION_DENIED,
  RESOURCE_EXHAUSTED,
  FAILED_PRECONDITION,
  ABORTED,
  OUT_OF_RANGE,
  UNIMPLEMENTED,
  INTERNAL,
  UNAVAILABLE,
  DATA_LOSS,
  UNAUTHENTICATED
}

Map<int, GRPCError> CodeToError = {
  0: GRPCError.OK,
  1: GRPCError.CANCELLED,
  2: GRPCError.UNKNOWN,
  3: GRPCError.INVALID_ARGUMENT,
  4: GRPCError.DEADLINE_EXCEEDED,
  5: GRPCError.NOT_FOUND,
  6: GRPCError.ALREADY_EXISTS,
  7: GRPCError.PERMISSION_DENIED,
  8: GRPCError.RESOURCE_EXHAUSTED,
  9: GRPCError.FAILED_PRECONDITION,
  10: GRPCError.ABORTED,
  11: GRPCError.OUT_OF_RANGE,
  12: GRPCError.UNIMPLEMENTED,
  13: GRPCError.INTERNAL,
  14: GRPCError.UNAVAILABLE,
  15: GRPCError.DATA_LOSS,
  16: GRPCError.UNAUTHENTICATED
};