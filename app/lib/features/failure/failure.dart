import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class Failure {
  final String message;

  Failure(this.message);

  factory Failure.fromDioError(DioException e) {
    if (kDebugMode) {
      print(e.toString());
    }
    return Failure('Connection Error: ${e.message ?? 'Unknown error'}');
  }

  factory Failure.fromAppError(Exception e) {
    if (kDebugMode) {
      print(e.toString());
    }
    return Failure('App Error: ${e.toString()}');
  }

  factory Failure.fromFirestoreError(FirebaseException e) {
    if (kDebugMode) {
      print(e.toString());
    }
    return Failure('Firestore Error: ${e.message ?? 'Unknown error'}');
  }
}
