import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;
import 'package:flutterquiz/core/constants/constants.dart';
import 'package:flutterquiz/features/auth/auth_exception.dart';
import 'package:flutterquiz/features/auth/cubits/auth_cubit.dart';
import 'package:flutterquiz/utils/api_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

  //to addUser
  Future<Map<String, dynamic>> addUser({
    required String firebaseId,
    required String type,
    required String name,
    String? profile,
    String? mobile,
    String? email,
    String? referCode,
    String? friendCode,
    String? appLanguage,
  }) async {
    print('👤 [AuthRemoteDataSource] Attempting to add new user...');
    print('👤 [AuthRemoteDataSource] URL: $addUserUrl');
    
    try {
      final fcmToken = await getFCMToken();
      print('👤 [AuthRemoteDataSource] FCM Token: ${fcmToken.substring(0, 10)}...');
      
      //body of post request
      final body = <String, String>{
        firebaseIdKey: firebaseId,
        typeKey: type,
        nameKey: name,
        emailKey: email ?? '',
        profileKey: profile ?? '',
        mobileKey: mobile ?? '',
        fcmIdKey: fcmToken,
        friendCodeKey: friendCode ?? '',
        'app_language': appLanguage ?? '',
      };

      print('👤 [AuthRemoteDataSource] Request body: $body');

      final response = await http.post(
        Uri.parse(addUserUrl), 
        body: body,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          print('👤 [AuthRemoteDataSource] ⏰ Request timeout after 30 seconds');
          throw Exception('Request timeout');
        },
      );
      
      print('👤 [AuthRemoteDataSource] Response status: ${response.statusCode}');
      print('👤 [AuthRemoteDataSource] Response headers: ${response.headers}');
      print('👤 [AuthRemoteDataSource] Response body length: ${response.body.length}');
      
      // Check if response is HTML (indicates an error page)
      if (response.body.toLowerCase().contains('<html') || 
          response.body.toLowerCase().contains('<!doctype')) {
        print('👤 [AuthRemoteDataSource] ❌ Server returned HTML instead of JSON!');
        print('👤 [AuthRemoteDataSource] ❌ This usually means an error page was returned');
        
        // Check for specific Firebase configuration error
        if (response.body.contains('CONFIGURATION_NOT_FOUND')) {
          print('👤 [AuthRemoteDataSource] 🔧 Firebase configuration error detected on server');
          print('👤 [AuthRemoteDataSource] 🔧 Error: CONFIGURATION_NOT_FOUND');
          print('👤 [AuthRemoteDataSource] 🔧 This means Firebase is not properly configured on the backend');
          throw AuthException(errorMessageCode: 'Backend Firebase configuration missing. Please contact admin.');
        }
        
        throw AuthException(errorMessageCode: 'Server returned error page instead of JSON');
      }
      
      // Split large response into chunks for better logging
      final responseBody = response.body;
      const int chunkSize = 500;
      for (int i = 0; i < responseBody.length; i += chunkSize) {
        final end = (i + chunkSize < responseBody.length) ? i + chunkSize : responseBody.length;
        print('👤 [AuthRemoteDataSource] Response body chunk ${(i ~/ chunkSize) + 1}: ${responseBody.substring(i, end)}');
      }
      
      // Check if response body is empty
      if (response.body.isEmpty) {
        print('👤 [AuthRemoteDataSource] ❌ Empty response body received!');
        throw AuthException(errorMessageCode: 'Empty response from server');
      }
      
      try {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        print('👤 [AuthRemoteDataSource] ✅ JSON parsed successfully: $responseJson');

        if (responseJson['error'] as bool) {
          print('👤 [AuthRemoteDataSource] ❌ API returned error: ${responseJson['message']}');
          throw AuthException(
            errorMessageCode: responseJson['message'].toString(),
          );
        }
        
        final userData = responseJson['data'] as Map<String, dynamic>?;
        if (userData == null) {
          print('👤 [AuthRemoteDataSource] ❌ Response data is null');
          throw AuthException(errorMessageCode: 'No user data returned from server');
        }
        
        print('👤 [AuthRemoteDataSource] ✅ User added successfully');
        print('👤 [AuthRemoteDataSource] ✅ User data: $userData');
        return userData;
      } catch (e) {
        print('👤 [AuthRemoteDataSource] ❌ JSON parsing error: $e');
        print('👤 [AuthRemoteDataSource] ❌ Response body that failed to parse: ${response.body}');
        throw AuthException(errorMessageCode: 'Invalid response format from server: $e');
      }
    } on SocketException catch (_) {
      print('👤 [AuthRemoteDataSource] ❌ Socket Exception - No internet');
      throw AuthException(errorMessageCode: errorCodeNoInternet);
    } on AuthException catch (e) {
      print('👤 [AuthRemoteDataSource] ❌ Auth Exception: $e');
      throw AuthException(errorMessageCode: e.toString());
    } on Exception catch (e) {
      print('👤 [AuthRemoteDataSource] ❌ General Exception: $e');
      throw AuthException(errorMessageCode: errorCodeDefaultMessage);
    }
  }

  //to addUser
  Future<String> getJWTTokenOfUser({
    required String firebaseId,
    required String type,
  }) async {
    try {
      //body of post request
      final body = <String, String>{firebaseIdKey: firebaseId, typeKey: type};

      final response = await http.post(Uri.parse(addUserUrl), body: body);
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      if (responseJson['error'] as bool) {
        throw AuthException(
          errorMessageCode: responseJson['message'].toString(),
        );
      }
      final data = responseJson['data'] as Map<String, dynamic>;

      return data['api_token'].toString();
    } on SocketException catch (_) {
      throw AuthException(errorMessageCode: errorCodeNoInternet);
    } on AuthException catch (e) {
      throw AuthException(errorMessageCode: e.toString());
    } on Exception catch (_) {
      throw AuthException(errorMessageCode: errorCodeDefaultMessage);
    }
  }

  Future<bool> isUserExist(String firebaseId) async {
    print('🌐 [AuthRemoteDataSource] Checking if user exists in backend...');
    print('🌐 [AuthRemoteDataSource] URL: $checkUserExistUrl');
    print('🌐 [AuthRemoteDataSource] Firebase ID: $firebaseId');
    
    try {
      final body = {firebaseIdKey: firebaseId};
      print('🌐 [AuthRemoteDataSource] Request body: $body');
      
      final response = await http.post(
        Uri.parse(checkUserExistUrl),
        body: body,
      );
      
      print('🌐 [AuthRemoteDataSource] Response status: ${response.statusCode}');
      print('🌐 [AuthRemoteDataSource] Response body: ${response.body}');
      
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      if (responseJson['error'] as bool) {
        print('🌐 [AuthRemoteDataSource] ❌ API returned error: ${responseJson['message']}');
        throw AuthException(
          errorMessageCode: responseJson['message'].toString(),
        );
      }

      final userExists = responseJson['message'].toString() == errorCodeUserExists;
      print('🌐 [AuthRemoteDataSource] User exists: $userExists');
      return userExists;
    } on SocketException catch (_) {
      print('🌐 [AuthRemoteDataSource] ❌ Socket Exception - No internet');
      throw AuthException(errorMessageCode: errorCodeNoInternet);
    } on AuthException catch (e) {
      print('🌐 [AuthRemoteDataSource] ❌ Auth Exception: $e');
      throw AuthException(errorMessageCode: e.toString());
    } on Exception catch (e) {
      print('🌐 [AuthRemoteDataSource] ❌ General Exception: $e');
      throw AuthException(errorMessageCode: errorCodeDefaultMessage);
    }
  }

  Future<void> updateFcmId({
    required String firebaseId,
    required bool userLoggingOut,
  }) async {
    try {
      final fcmId = userLoggingOut
          ? ''
          : await fcm.FirebaseMessaging.instance.getToken() ?? '';
      final body = {
        fcmIdKey: fcmId,
        firebaseIdKey: firebaseId.isNotEmpty ? firebaseId : 'firebaseId',
      };
      final response = await http.post(
        Uri.parse(updateFcmIdUrl),
        body: body,
        headers: await ApiUtils.getHeaders(),
      );
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      /// Ignore Error when user is logging out. as old token would be expired and
      /// you will always get 129 something went wrong error.
      if (!userLoggingOut && responseJson['error'] as bool) {
        throw AuthException(
          errorMessageCode: responseJson['message'].toString(),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  //signIn using phone number
  Future<UserCredential> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    final phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(
      phoneAuthCredential,
    );
    return userCredential;
  }

  //SignIn user will accept AuthProvider (enum)
  Future<UserCredential> signInUser(
    AuthProviders authProvider, {
    String? email,
    String? password,
    String? verificationId,
    String? smsCode,
  }) async {
    print('🔥 [AuthRemoteDataSource] Starting signInUser with provider: ${authProvider.name}');
    try {
      UserCredential userCredential;
      switch (authProvider) {
        case AuthProviders.gmail:
          print('🔥 [AuthRemoteDataSource] Signing in with Google...');
          userCredential = await signInWithGoogle();
          break;
        case AuthProviders.mobile:
          print('🔥 [AuthRemoteDataSource] Signing in with mobile...');
          userCredential = await signInWithPhoneNumber(
            verificationId: verificationId!,
            smsCode: smsCode!,
          );
          break;
        case AuthProviders.email:
          print('🔥 [AuthRemoteDataSource] Signing in with email/password...');
          userCredential = await signInWithEmailAndPassword(
            email!,
            password!,
          );
          break;
        default:
          print('🔥 [AuthRemoteDataSource] Signing in with Apple...');
          userCredential = await signInWithApple();
          break;
      }
      print('🔥 [AuthRemoteDataSource] ✅ Authentication successful');
      return userCredential;
    } on SocketException catch (e) {
      print('🔥 [AuthRemoteDataSource] ❌ Socket Exception: $e');
      throw AuthException(errorMessageCode: errorCodeNoInternet);
    } on FirebaseAuthException catch (e) {
      print('🔥 [AuthRemoteDataSource] ❌ Firebase Auth Exception: ${e.code} - ${e.message}');
      throw AuthException(errorMessageCode: firebaseErrorCodeToNumber(e.code));
    } on AuthException catch (e) {
      print('🔥 [AuthRemoteDataSource] ❌ Auth Exception: $e');
      throw AuthException(errorMessageCode: e.toString());
    } on Exception catch (e) {
      print('🔥 [AuthRemoteDataSource] ❌ General Exception: $e');
      throw AuthException(errorMessageCode: errorCodeDefaultMessage);
    }
  }

  //signIn using google account
  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw AuthException(errorMessageCode: errorCodeDefaultMessage);
    }
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        oAuthCredential,
      );

      if (userCredential.additionalUserInfo!.isNewUser ||
          userCredential.user!.displayName == null) {
        final user = userCredential.user!;
        final givenName = credential.givenName ?? '';
        final familyName = credential.familyName ?? '';

        await user.updateDisplayName('$givenName $familyName');
        await user.reload();
      }

      return userCredential;
    } on Exception catch (_) {
      throw AuthException(errorMessageCode: errorCodeDefaultMessage);
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    print('📧 [AuthRemoteDataSource] Attempting email/password sign-in');
    print('📧 [AuthRemoteDataSource] Email: $email');
    print('📧 [AuthRemoteDataSource] Password length: ${password.length}');
    
    try {
      //sign in using email
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('📧 [AuthRemoteDataSource] ✅ Firebase sign-in successful');
      print('📧 [AuthRemoteDataSource] User ID: ${userCredential.user?.uid}');
      print('📧 [AuthRemoteDataSource] Email verified: ${FirebaseAuth.instance.currentUser?.emailVerified}');
      
      if (userCredential.user!.emailVerified) {
        print('📧 [AuthRemoteDataSource] ✅ Email verification confirmed');
        return userCredential;
      } else {
        print('📧 [AuthRemoteDataSource] ❌ Email not verified');
        throw AuthException(errorMessageCode: errorCodeVerifyEmail);
      }
    } catch (e) {
      print('📧 [AuthRemoteDataSource] ❌ Email sign-in failed: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Resend email verification
  Future<void> resendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification(
        ActionCodeSettings(
          url: 'https://test.grihasth.com',
          handleCodeInApp: true,
          androidPackageName: 'com.nextwave.thetestpoint',
          iOSBundleId: 'com.nextwave.thetestpoint',
        ),
      );
    }
  }

  // Check if email is verified
  bool isEmailVerified() {
    final user = _firebaseAuth.currentUser;
    return user?.emailVerified ?? false;
  }

  static Future<String> getFCMToken() async {
    try {
      return await fcm.FirebaseMessaging.instance.getToken() ?? '';
    } on Exception catch (_) {
      return '';
    }
  }

  //create user account
  Future<void> signUpUser(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //verify email address
      await userCredential.user!.sendEmailVerification(
        ActionCodeSettings(
          url: 'https://test.grihasth.com', // Your app's URL
          handleCodeInApp: true,
          androidPackageName: 'com.nextwave.thetestpoint',
          iOSBundleId: 'com.nextwave.thetestpoint',
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Log the specific Firebase error for debugging
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      throw AuthException(errorMessageCode: firebaseErrorCodeToNumber(e.code));
    } on SocketException catch (_) {
      throw AuthException(errorMessageCode: errorCodeNoInternet);
    } on Exception catch (e) {
      // Log general exceptions for debugging
      print('General Exception during signup: $e');
      throw AuthException(errorMessageCode: errorCodeDefaultMessage);
    }
  }

  Future<void> signOut(AuthProviders? authProvider) async {
    await _firebaseAuth.signOut();
    if (authProvider == AuthProviders.gmail) {
      await _googleSignIn.signOut();
    }
  }
}
