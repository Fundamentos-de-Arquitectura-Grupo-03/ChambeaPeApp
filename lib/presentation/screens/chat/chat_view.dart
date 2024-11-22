import 'dart:convert';
import 'dart:io';

import 'package:chambeape/config/utils/login_user_data.dart';
import 'package:chambeape/infrastructure/models/chat_message.dart' as Message;
import 'package:chambeape/infrastructure/models/login/login_response.dart';
import 'package:chambeape/presentation/screens/chat/negotiation_dialog_view.dart';
import 'package:chambeape/presentation/shared/enums/enum.dart';
import 'package:chambeape/services/chat/message_service.dart';
import 'package:chambeape/services/media/MediaService.dart';
import 'package:chambeape/services/users/user_service.dart';
import 'package:crypto/crypto.dart';
import 'package:chambeape/infrastructure/models/users.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:photo_view/photo_view.dart';

class ChatView extends StatefulWidget {
  final Users otherUser;

  const ChatView({super.key, required this.otherUser});
  static const String routeName = 'chat_view';

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  StompClient? stompClient;
  late String roomId;
  late List<Message.ChatMessage> messages = [];
  late Users? currentUser;
  late ChatUser? chatCurrentUser, chatOtherUser;
  late Future<void> loadChatFuture;
  MediaService mediaService = MediaService();
  late String fileName;
  bool allowNegotiation = false;

  @override
  void initState() {
    super.initState();
    loadChatFuture = initializeChat();
  }

  Future<void> initializeChat() async {
    currentUser = await getCurrentUser();
    if (currentUser == null) {
      throw Exception("Current user not found.");
    }
    allowNegotiation = currentUser!.userRole == UserRole.E.name;

    roomId = generateChatRoomId(
        currentUser!.id.toString(), widget.otherUser.id.toString());
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'https://chambeape-chat.azurewebsites.net/websocket',
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    stompClient?.activate();
    await loadMessages();
    await loadChatUsers();
  }

  Future<Users?> getCurrentUser() async {
    LoginResponse user = LoginData().user;
    user = await LoginData().loadSession();
    var userId = user.id;

    Users currentUser = await UserService().getUserById(userId);
    return currentUser;
  }

  Future<void> loadChatUsers() async {
    chatCurrentUser = ChatUser(
      id: currentUser!.id.toString(),
      firstName: currentUser!.firstName.split(' ')[0],
      lastName: currentUser!.lastName.split(' ')[0],
      profileImage: currentUser!.profilePic,
    );
    chatOtherUser = ChatUser(
      id: widget.otherUser.id.toString(),
      firstName: widget.otherUser.firstName.split(' ')[0],
      lastName: widget.otherUser.lastName.split(' ')[0],
      profileImage: widget.otherUser.profilePic,
    );
  }

  String generateChatRoomId(String currentUserId, String otherUserId) {
    List<String> ids = [currentUserId, otherUserId];
    ids.sort();
    String combinedIds = '${ids[0]}_${ids[1]}';
    var bytes = utf8.encode(combinedIds);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> loadMessages() async {
    List<Message.ChatMessage> loadedMessages =
        await MessageService().getMessages(roomId);
    setState(() {
      messages = loadedMessages;
    });
  }

  void onConnect(StompFrame frame) {
    stompClient?.subscribe(
      destination: '/topic/$roomId',
      callback: (frame) {
        if (frame.body != null) {
          setState(() {
            Message.ChatMessage lastMessage =
                Message.ChatMessage.fromJson(jsonDecode(frame.body!));
            messages.add(lastMessage);
          });
        }
      },
    );
  }

  void sendMessage(ChatMessage chatMessage) {
    String message;
    String type;

    if (stompClient != null && stompClient!.connected) {
      if (chatMessage.medias != null && chatMessage.medias!.isNotEmpty) {
        message = chatMessage.medias!.first.url;
        switch (chatMessage.medias!.first.type) {
          case MediaType.image:
            type = 'media/image';
            break;
          case MediaType.video:
            type = 'media/video';
            break;
          default:
            type = 'media/file';
            break;
        }
      } else {
        message = chatMessage.text;
        type = 'text';
      }

      stompClient?.send(
        destination: '/app/chat/$roomId',
        body:
            '{"content":"$message","type":"$type","user":"${currentUser!.id.toString()}"}',
      );
    }
  }

  List<ChatMessage> getMessagesList() {
    List<ChatMessage> chatMessages = messages.map((e) {
      DateTime localTime = convertToLocalTime(e.timestamp);

      String messageText;
      List<ChatMedia>? messageMedias;

      if (e.type == 'text') {
        messageText = e.content;
        messageMedias = null;
      } else {
        messageText = '';
        String fileType = e.type.split('/')[1];
        MediaType mediaType;
        switch (fileType) {
          case 'image':
            mediaType = MediaType.image;
            break;
          case 'video':
            mediaType = MediaType.video;
            break;
          default:
            mediaType = MediaType.file;
            break;
        }
        String fileName = e.content.split('/').last;
        fileName = fileName.split('?').first;

        messageMedias = [
          ChatMedia(
              url: e.content,
              fileName: mediaType == MediaType.file ? fileName : '',
              type: mediaType)
        ];
      }

      return ChatMessage(
        text: messageText,
        medias: messageMedias,
        user: e.user == chatCurrentUser?.id ? chatCurrentUser! : chatOtherUser!,
        createdAt: localTime,
      );
    }).toList();

    chatMessages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return chatMessages;
  }

  DateTime convertToLocalTime(String timestamp) {
    final utcTime = DateTime.parse('${timestamp}Z');
    final lima = tz.getLocation('America/Lima');
    tz.setLocalLocation(lima);
    TZDateTime limaTime = TZDateTime.from(utcTime, lima);
    return limaTime;
  }

  @override
  void dispose() {
    stompClient?.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.otherUser.profilePic),
          ),
          const SizedBox(width: 10),
          Text(widget.otherUser.firstName),
        ]),
        actions: [
          allowNegotiation ? IconButton(
            icon: Icon(Icons.monetization_on_sharp, color: Colors.amber.shade700,),
            iconSize: 30,
            onPressed: () {
              showDialog(
                context: context, 
                builder: (BuildContext context) {
                  return NegotiationDialogView(currentUser: currentUser!, otherUser: widget.otherUser,);
                }
                );
            },
          ): Container(),
        ],
      ),
      body: FutureBuilder<void>(
        future: loadChatFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error loading chat. Please try again later'));
          } else {
            return DashChat(
              messageOptions: MessageOptions(
                showOtherUsersAvatar: true,
                showTime: true,
                onTapMedia: (media) {
                  if (media.type == MediaType.image) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Container(
                                    child: PhotoView(
                                  imageProvider: NetworkImage(media.url),
                                ))));
                  }
                },
              ),
              inputOptions: InputOptions(
                  alwaysShowSend: true,
                  sendOnEnter: true,
                  trailing: [mediaMessageButton()],
                  inputDecoration: InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  )),
              currentUser: chatCurrentUser!,
              onSend: sendMessage,
              messages: getMessagesList(),
            );
          }
        },
      ),
    );
  }

  Widget mediaMessageButton() {
    return IconButton(
      icon: Icon(
        Icons.image,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () async {
        File? file = await mediaService.getImageOrVideoFromGallery();
        if (file != null) {
          fileName = mediaService.getFileName(file.path);
          MediaType mediaType = mediaService.getChatMessageMediaType(fileName);
          Uri fileUrl = await mediaService.saveFileToGoogleCloud(file);

          ChatMessage chatMessage = ChatMessage(
              user: chatCurrentUser!,
              createdAt: DateTime.now(),
              medias: [
                ChatMedia(
                    url: fileUrl.toString(),
                    fileName: fileName,
                    type: mediaType)
              ]);

          sendMessage(chatMessage);
        }
      },
    );
  }
}
