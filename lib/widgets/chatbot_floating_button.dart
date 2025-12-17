import 'package:flutter/material.dart';
import 'food_chatbot_widget.dart';

class ChatbotFloatingButton extends StatelessWidget {
  const ChatbotFloatingButton({super.key});

  void _openChatbot(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          alignment: Alignment.bottomRight,
          insetPadding: const EdgeInsets.all(24),
          backgroundColor: Colors.transparent,
          child: const FoodChatbotWidget(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24,
      bottom: 24,
      child: FloatingActionButton.extended(
        onPressed: () => _openChatbot(context),
        backgroundColor: const Color(0xFF7ed321),
        elevation: 8,
        icon: const Icon(
          Icons.chat_bubble,
          color: Colors.black,
        ),
        label: const Text(
          'Food AI',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
