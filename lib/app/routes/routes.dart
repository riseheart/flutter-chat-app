import 'package:chatapp/app/app.dart';
import 'package:chatapp/dashboard/dashboard.dart';
import 'package:chatapp/login/login.dart';
import 'package:flutter/material.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [Dashboard.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
