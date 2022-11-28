import 'dart:io';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool _isWritting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: const Text('Te', style: TextStyle( fontSize: 12) ),
            ),
            const SizedBox(height: 3 ),
            const Text('Alan Turing', style: TextStyle( color: Colors.black87, fontSize: 12 ) )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: ( _, i ) => _messages[i],
                itemCount: _messages.length,
                reverse: true,
              )
            ),
            const Divider( height: 1 ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric( horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(  
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String text){
                  setState(() {
                    if( text.trim().isNotEmpty) {
                      _isWritting = true;
                    } else {
                      _isWritting = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              ) 
            ),
            Container(
              margin: const EdgeInsets.symmetric( horizontal: 4.0),
              child: Platform.isIOS 
                ? CupertinoButton(
                  onPressed: _isWritting 
                      ? () => _handleSubmit(_textController.text) 
                      : null,
                  child: const Text('Enviar'), 
                )
                : Container(
                  margin: const EdgeInsets.symmetric( horizontal: 4.0 ),
                  child: IconTheme(
                    data: IconThemeData( color: Colors.blue[400] ),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: const Icon( Icons.send ),
                      onPressed: _isWritting 
                      ? () => _handleSubmit(_textController.text) 
                      : null,
                    ),
                  ),
                ),
            )
          ],
        ),
      )
    );
  }

  _handleSubmit( String text) {

    if(text.isEmpty) return;
    final ChatMessage newMessage = ChatMessage(
      text: text, 
      uuid: '123', 
      animationController: AnimationController( vsync: this, duration: const Duration( milliseconds: 200)) 
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWritting = false;
      _textController.clear();
      _focusNode.requestFocus();
    });
    
  }
  @override
  void dispose() {
    for( ChatMessage message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }
}