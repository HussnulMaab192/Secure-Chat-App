import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_constants.dart';
import 'core/network/api_client.dart';
import 'core/utils/secure_storage.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/datasources/message_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/message_repository_impl.dart';
import 'domain/usecases/get_messages.dart';
import 'domain/usecases/post_message.dart';
import 'domain/usecases/sign_in.dart';
import 'domain/usecases/sign_up.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/message_provider.dart';
import 'presentation/screens/chat_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/signup_screen.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize dependencies
  final secureStorage = SecureStorage(sharedPreferences);
  final httpClient = http.Client();
  final apiClient = ApiClient(client: httpClient, secureStorage: secureStorage);

  // Data sources
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: apiClient);
  final messageRemoteDataSource = MessageRemoteDataSourceImpl(client: apiClient);

  // Repositories
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    secureStorage: secureStorage,
  );
  final messageRepository = MessageRepositoryImpl(
    remoteDataSource: messageRemoteDataSource,
  );

  // Use cases
  final signUp = SignUp(authRepository);
  final signIn = SignIn(authRepository);
  final getMessages = GetMessages(messageRepository);
  final postMessage = PostMessage(messageRepository);

  runApp(
    MyApp(
      signUp: signUp,
      signIn: signIn,
      getMessages: getMessages,
      postMessage: postMessage,
    ),
  );
}

class MyApp extends StatelessWidget {
  final SignUp signUp;
  final SignIn signIn;
  final GetMessages getMessages;
  final PostMessage postMessage;

  const MyApp({
    Key? key,
    required this.signUp,
    required this.signIn,
    required this.getMessages,
    required this.postMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            signUp: signUp,
            signIn: signIn,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageProvider(
            getMessages: getMessages,
            postMessage: postMessage,
          ),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (_) => const SplashScreen(),
          LoginScreen.routeName: (_) => const LoginScreen(),
          SignupScreen.routeName: (_) => const SignupScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          ChatScreen.routeName: (_) => const ChatScreen(),
        },
      ),
    );
  }
}
