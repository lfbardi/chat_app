import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class GlobalModel extends Model {
  BuildContext rootBuildContext;
  Directory directory;
  String greeting = '';
  String username = '';
  static final String defaultRoomName = 'Not currently in a room';
  String currentRoomName = defaultRoomName;
  List currentRoomUserList = [];
  bool currentRoomEnabled = false;
  List currentRoomMessages = [];
  List roomList = [];
  List userList = [];
  bool adminFunctionsEnabled = false;
  Map roomInvites = {};

  void setGreeting(String newGreeting) {
    greeting = newGreeting;
    notifyListeners();
  }

  void setUsername(String newUsername) {
    username = newUsername;
    notifyListeners();
  }

  void setCurrentRoom(String currentRoom) {
    currentRoomName = currentRoom;
    notifyListeners();
  }

  void setAdminFunctionsEnabled(bool adminFEnabled) {
    adminFunctionsEnabled = adminFEnabled;
    notifyListeners();
  }

  void setCurrentRoomEnabled(bool currentREnabled) {
    currentRoomEnabled = currentREnabled;
    notifyListeners();
  }

  void addMessage(String username, String message) {
    currentRoomMessages.add({ 'username' : username, 'message': message });
    notifyListeners();
  }

  void setRoomList(Map roomListMap) {
    List rooms = [];
    for(String roomName in roomListMap.keys) {
      Map room = roomListMap[roomName];
      rooms.add(room);
    }
    roomList = rooms;
    notifyListeners();
  }

  void setUserList(Map newUserList) {
    List users = [];
    for (String username in newUserList.keys) {
      Map user = newUserList[username];
      users.add(user);
    }
    userList = users;
    notifyListeners();
  }

  void setCurrentRoomUserList(Map newUserList) {
    List users = [];
    for (String username in newUserList.keys) {
      Map user = newUserList[username];
      users.add(user);
    }
    userList = users;
    notifyListeners();
  }
  
  void addRoomInvite(String roomName) => roomInvites[roomName] = true;

  void removeRoomInvite(String roomName) => roomInvites.remove(roomName);

  void clearCurrentRoomMessages() => currentRoomMessages = [];
}

GlobalModel model = GlobalModel();