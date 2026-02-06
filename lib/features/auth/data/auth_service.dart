import 'dart:developer' as developer;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/config/env.dart';
import '../../../core/network/api_client.dart';
import '../domain/user.dart';

class AuthResult {
  final String accessToken;
  final User user;

  const AuthResult({required this.accessToken, required this.user});
}

class AuthService {
  final ApiClient _apiClient;
  bool _initialized = false;

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    final serverClientId = Env.googleServerClientId;
    developer.log(
      'Initializing Google Sign-In with serverClientId: $serverClientId',
      name: 'AuthService',
    );
    await GoogleSignIn.instance.initialize(serverClientId: serverClientId);
    _initialized = true;
  }

  Future<AuthResult> signInWithGoogle() async {
    await _ensureInitialized();

    // Try lightweight auth first, then full authenticate
    GoogleSignInAccount? googleUser;

    try {
      googleUser = await GoogleSignIn.instance
          .attemptLightweightAuthentication();
    } catch (_) {
      // Lightweight failed, try full auth
    }

    if (googleUser == null) {
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        googleUser = await GoogleSignIn.instance.authenticate();
      } else {
        throw Exception('Google Sign-In not supported on this platform');
      }
    }

    // authenticate() returns non-nullable, but just in case
    final user = googleUser;

    // For backend auth, we need the server auth code
    // Backend will exchange this for tokens with Google
    final serverAuth = await user.authorizationClient.authorizeServer([
      'email',
      'profile',
      'openid',
    ]);

    if (serverAuth == null) {
      throw Exception('Failed to get server authorization');
    }

    developer.log(
      'Got server auth code, sending to backend',
      name: 'AuthService',
    );

    // Send server auth code to backend
    // Backend needs to exchange this with Google for idToken
    final response = await _apiClient.googleSignIn(serverAuth.serverAuthCode);

    final accessToken = response['accessToken'] as String;
    final userData = User.fromJson(response['user'] as Map<String, dynamic>);

    // Save token
    await _apiClient.saveToken(accessToken);

    return AuthResult(accessToken: accessToken, user: userData);
  }

  Future<void> signOut() async {
    await _ensureInitialized();
    await GoogleSignIn.instance.signOut();
    await _apiClient.clearToken();
  }

  Future<bool> isSignedIn() async {
    final token = await _apiClient.getToken();
    return token != null;
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiClient.getMe();
      final userData = response['user'] as Map<String, dynamic>;
      return User(
        id: userData['userId'] as String,
        email: userData['email'] as String,
        name: userData['email'] as String,
      );
    } catch (e) {
      return null;
    }
  }
}
