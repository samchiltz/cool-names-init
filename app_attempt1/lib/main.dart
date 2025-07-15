import 'package:app_attempt1/providers/gemini.dart';
import 'package:app_attempt1/services/gemini_chat_service.dart';
import 'package:colorist_ui/colorist_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  runApp(ProviderScope(child: MainApp()));
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
); 
}

class MainApp extends ConsumerWidget{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(geminiModelProvider);
    final conversationState = ref.watch(conversationStateProvider);

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
      ),
      home: model.when(
       data: (data) => MainScreen( 
        conversationState: conversationState,
        notifyColorSelection: (color) {
          ref.read(geminiChatServiceProvider).notifyColorSelection(color);
        },
        sendMessage: (text) {
          ref.read(geminiChatServiceProvider).sendMessage(text);
        },
      ),
      loading: () => LoadingScreen(message: 'Initializing Gemini Model',),
      error: (err, st) => ErrorScreen(error: err),
      ),    
    );
  }
}
  void sendMessage(String message, WidgetRef ref){
    final chatStateNotifier = ref.read(chatStateNotifierProvider.notifier);
    final logStateNotifier = ref.read(logStateNotifierProvider.notifier);

    chatStateNotifier.addUserMessage(message);
    logStateNotifier.logUserText(message);
    chatStateNotifier.addLlmMessage(message, MessageState.complete);
    logStateNotifier .logLlmText(message);

  }

