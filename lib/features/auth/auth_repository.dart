import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterquiz/core/constants/constants.dart';
import 'package:flutterquiz/features/auth/auth_exception.dart';
import 'package:flutterquiz/features/auth/auth_local_data_source.dart';
import 'package:flutterquiz/features/auth/auth_remote_data_source.dart';
import 'package:flutterquiz/features/auth/cubits/auth_cubit.dart';

class AuthRepository {
  factory AuthRepository() {
    _authRepository._authLocalDataSource = AuthLocalDataSource();
    _authRepository._authRemoteDataSource = AuthRemoteDataSource();
    return _authRepository;
  }

  AuthRepository._internal();

  static final AuthRepository _authRepository = AuthRepository._internal();
  late AuthLocalDataSource _authLocalDataSource;
  late AuthRemoteDataSource _authRemoteDataSource;

  //to get auth detials stored in hive box
  Map<String, dynamic> getLocalAuthDetails() {
    return {
      'isLogin': AuthLocalDataSource.checkIsAuth(),
      'jwtToken': AuthLocalDataSource.getJwtToken(),
      'firebaseId': AuthLocalDataSource.getUserFirebaseId(),
      'authProvider': getAuthProviderFromString(
        AuthLocalDataSource.getAuthType(),
      ),
    };
  }

  void setLocalAuthDetails({
    String? jwtToken,
    String? firebaseId,
    String? authType,
    bool? authStatus,
    bool? isNewUser,
  }) {
    _authLocalDataSource
      ..changeAuthStatus(authStatus: authStatus)
      ..setUserFirebaseId(firebaseId)
      ..setAuthType(authType);
  }

  //First we signing user with given provider then add user details
  Future<({bool isNewUser, User user})> signInUser(
    AuthProviders authProvider, {
    required String email,
    required String password,
    required String verificationId,
    required String smsCode,
    String? appLanguage,
  }) async {
    print('🔐 [AuthRepository] Starting signInUser with provider: ${authProvider.name}');
    print('🔐 [AuthRepository] Email: $email');
    print('🔐 [AuthRepository] Password length: ${password.length}');
    print('🔐 [AuthRepository] SMS Code: ${smsCode.isNotEmpty ? "Provided" : "Not provided"}');
    print('🔐 [AuthRepository] Verification ID: ${verificationId.isNotEmpty ? "Provided" : "Not provided"}');
    print('🔐 [AuthRepository] App Language: $appLanguage');
    
    try {
      print('[AuthRepository] Calling RemoteDataSource.signInUser...');
      final userCredentials = await _authRemoteDataSource.signInUser(
        authProvider,
        email: email,
        password: password,
        smsCode: smsCode,
        verificationId: verificationId,
      );
      print('[AuthRepository] ✅ RemoteDataSource.signInUser successful');

      final user = userCredentials.user;
      final additionalUserInfo = userCredentials.additionalUserInfo!;
      var isNewUser = additionalUserInfo.isNewUser;

      print('[AuthRepository] 🟢 User from credentials: ${user?.uid}');
      print('[AuthRepository] 🟢 Is new user: $isNewUser');
      print('[AuthRepository] 🟢 Additional user info: $additionalUserInfo');

      final firebaseUser = FirebaseAuth.instance.currentUser!;
      print('[AuthRepository] 🟢 Firebase current user: ${firebaseUser.uid}');

      final userEmail =
          user?.email ??
          additionalUserInfo.profile?['email'] as String? ??
          firebaseUser.email ??
          '';
      final userPhotoUrl =
          user?.photoURL ??
          additionalUserInfo.profile?['picture'] as String? ??
          firebaseUser.photoURL ??
          '';
      final userPhoneNumber =
          user?.phoneNumber ?? firebaseUser.phoneNumber ?? '';
      final userName =
          user?.displayName ??
          additionalUserInfo.profile?['name'] as String? ??
          firebaseUser.displayName ??
          '';
      final userUid = user!.uid;
      
      print('[AuthRepository] 🟢 Extracted user details:');
      print('[AuthRepository] 🟢 Email: $userEmail');
      print('[AuthRepository] 🟢 Name: $userName');
      print('[AuthRepository] 🟢 Phone: $userPhoneNumber');
      print('[AuthRepository] 🟢 Photo: $userPhotoUrl');
      print('[AuthRepository] 🟢 UID: $userUid');

      /// checks in panel
      var userExists = !isNewUser;
      print('[AuthRepository] 🟢 Initial userExists: $userExists');

      if (authProvider == AuthProviders.email) {
        print('[AuthRepository] 🔍 Checking if user exists in backend for email auth...');
        userExists = await _authRemoteDataSource.isUserExist(userUid);
        print('[AuthRepository] 🔍 Backend userExists check result: $userExists');
      }

      if (!userExists) {
        print("[AuthRepository] 📝 User doesn't exist, registering new user...");
        isNewUser = true;
        final registeredUser = await _authRemoteDataSource.addUser(
          email: userEmail,
          firebaseId: userUid,
          mobile: userPhoneNumber,
          name: userName,
          type: authProvider.name,
          profile: userPhotoUrl,
          appLanguage: appLanguage,
        );
        print('[AuthRepository] 📝 ✅ User registration successful: $registeredUser');

        await AuthLocalDataSource.setJwtToken(
          registeredUser['api_token'].toString(),
        );
        print('[AuthRepository] 📝 ✅ JWT token set locally');
      } else {
        print('[AuthRepository] 🔑 User exists, getting JWT token...');
        final jwtToken = await _authRemoteDataSource.getJWTTokenOfUser(
          firebaseId: userUid,
          type: authProvider.name,
        );
        print('[AuthRepository] 🔑 ✅ JWT token retrieved: ${jwtToken.substring(0, 10)}...');

        await AuthLocalDataSource.setJwtToken(jwtToken);
        print('[AuthRepository] 🔑 ✅ JWT token set locally');
        await _authRemoteDataSource.updateFcmId(
          firebaseId: userUid,
          userLoggingOut: false,
        );
        print('[AuthRepository] 🔑 ✅ FCM ID updated');
      }

      print('[AuthRepository] ✅ Sign in process completed successfully');
      return (user: user, isNewUser: isNewUser);
    } catch (e) {
      print('[AuthRepository] ❌ ERROR in signInUser: ${e.toString()}');
      print('[AuthRepository] ❌ Error type: ${e.runtimeType}');
      await signOut(authProvider);
      throw AuthException(errorMessageCode: e.toString());
    }
  }

  //to signUp user
  Future<void> signUpUser(String email, String password) async {
    try {
      await _authRemoteDataSource.signUpUser(email, password);
    } catch (e) {
      if (e.toString() != errorCodeEmailExists) {
        await signOut(AuthProviders.email);
      }
      throw AuthException(errorMessageCode: e.toString());
    }
  }

  Future<void> signOut(AuthProviders? authProvider) async {
    try {
      // Deregister user's device from FCM to prevent receiving notifications.
      await _authRemoteDataSource.updateFcmId(
        firebaseId: AuthLocalDataSource.getUserFirebaseId(),
        userLoggingOut: true,
      );
      await _authRemoteDataSource.signOut(authProvider);
      setLocalAuthDetails(
        authStatus: false,
        authType: '',
        jwtToken: '',
        firebaseId: '',
        isNewUser: false,
      );
    } catch (e) {
      rethrow;
    }
  }

  //to add user's data to database. This will be in use when authenticating using phoneNumber
  Future<Map<String, dynamic>> addUserData({
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
    try {
      final result = await _authRemoteDataSource.addUser(
        email: email,
        firebaseId: firebaseId,
        friendCode: friendCode,
        mobile: mobile,
        name: name,
        profile: profile,
        referCode: referCode,
        type: type,
        appLanguage: appLanguage,
      );

      //Update jwt token
      await AuthLocalDataSource.setJwtToken(result['api_token'].toString());

      return Map.from(result); //
    } catch (e) {
      await signOut(AuthProviders.mobile);
      throw AuthException(errorMessageCode: e.toString());
    }
  }

  AuthProviders getAuthProviderFromString(String? value) {
    AuthProviders authProvider;
    if (value == 'gmail') {
      authProvider = AuthProviders.gmail;
    } else if (value == 'mobile') {
      authProvider = AuthProviders.mobile;
    } else if (value == 'apple') {
      authProvider = AuthProviders.apple;
    } else {
      authProvider = AuthProviders.email;
    }
    return authProvider;
  }
}
