import 'package:flutter/widgets.dart';

/// Clean result type wrapper for Clean Architecture Use Cases.
@immutable
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const Result.success(this.data)
      : error = null,
        isSuccess = true;

  const Result.failure(this.error)
      : data = null,
        isSuccess = false;

  R fold<R>(R Function(String error) onFailure, R Function(T data) onSuccess) {
    if (isSuccess) {
      return onSuccess(data as T);
    } else {
      return onFailure(error ?? 'An unexpected error occurred');
    }
  }
}
