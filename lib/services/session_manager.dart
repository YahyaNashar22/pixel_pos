import 'package:pixel_pos/models/company_model.dart';
import 'package:pixel_pos/models/user_model.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() => _instance;

  SessionManager._internal();

  UserModel? currentUser;
  CompanyModel? currentCompany;

  void setUser(UserModel user) {
    currentUser = user;
  }

  void setCompany(CompanyModel company) {
    currentCompany = company;
  }

  void clear() {
    currentUser = null;
    currentCompany = null;
  }
}
