import 'package:celebritysystems_mobile/core/helpers/constants.dart';
import 'package:celebritysystems_mobile/core/helpers/shared_pref_helper.dart';
import 'package:celebritysystems_mobile/core/helpers/token_service.dart';

/// Utility class to extract and save token data consistently across the app
/// This ensures that whether a user comes from splash screen or direct login,
/// the same token parsing logic is applied
class TokenDataExtractor {
  /// Extracts and saves token data to SharedPreferences
  /// This method should be called after any successful login or token validation
  static Future<bool> extractAndSaveTokenData(String? token,
      {String? source}) async {
    if (token == null || token.isEmpty) {
      print("$source: No token provided for extraction");
      return false;
    }

    try {
      final tokenService = TokenService(token);

      // Save user data
      await SharedPrefHelper.setData(
          SharedPrefKeys.username, tokenService.username);
      await SharedPrefHelper.setData(
          SharedPrefKeys.userId, tokenService.userId);

      // Save companyId if user is a company role
      if (tokenService.role == Constants.COMPANY) {
        print("$source: Saving companyId ${tokenService.companyId}");
        await SharedPrefHelper.setData(
            SharedPrefKeys.companyId, tokenService.companyId);
      }

      print("$source: Token data extracted and saved successfully");
      print("$source: Username: ${tokenService.username}");
      print("$source: UserId: ${tokenService.userId}");
      print("$source: Role: ${tokenService.role}");
      if (tokenService.role == Constants.COMPANY) {
        print("$source: CompanyId: ${tokenService.companyId}");
      }

      return true;
    } catch (e) {
      print("$source: Error extracting token data: $e");
      return false;
    }
  }

  /// Validates if a token is valid and not expired
  static bool isTokenValid(String? token) {
    if (token == null || token.isEmpty) return false;

    try {
      final tokenService = TokenService(token);
      return !tokenService.isExpired;
    } catch (e) {
      print("TokenDataExtractor: Error validating token: $e");
      return false;
    }
  }

  /// Gets user role from token
  static String? getUserRole(String? token) {
    if (token == null || token.isEmpty) return null;

    try {
      final tokenService = TokenService(token);
      return tokenService.role;
    } catch (e) {
      print("TokenDataExtractor: Error getting user role: $e");
      return null;
    }
  }

  /// Gets company ID from token (only for company users)
  static int? getCompanyId(String? token) {
    if (token == null || token.isEmpty) return null;

    try {
      final tokenService = TokenService(token);
      if (tokenService.role == Constants.COMPANY) {
        return tokenService.companyId;
      }
      return null;
    } catch (e) {
      print("TokenDataExtractor: Error getting company ID: $e");
      return null;
    }
  }
}
