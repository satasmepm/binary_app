// GENERATED CODE - DO NOT MODIFY BY HAND

part of objects;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserZoomLinkModel _$UserZoomLinkModelFromJson(Map<String, dynamic> json) =>
    UserZoomLinkModel(
      course_pay_id: json['course_pay_id'] as String,
      group_id: json['group_id'] as String,
      group_image: json['group_image'] as String,
      group_name: json['group_name'] as String,
      use_id: json['use_id'] as String,
      zoom_links: json['zoom_links'] as List<dynamic>,
      zoom_links_id: json['zoom_links_id'] as String,
    );

Map<String, dynamic> _$UserZoomLinkModelToJson(UserZoomLinkModel instance) =>
    <String, dynamic>{
      'course_pay_id': instance.course_pay_id,
      'group_id': instance.group_id,
      'group_image': instance.group_image,
      'group_name': instance.group_name,
      'use_id': instance.use_id,
      'zoom_links': instance.zoom_links,
      'zoom_links_id': instance.zoom_links_id,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] as String,
      stunumber: json['stunumber'] as String,
      email: json['email'] as String,
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      phone: json['phone'] as String,
      homenumber: json['homenumber'] as String,
      image: json['image'] as String,
      token: json['token'] as String,
      signature: json['signature'] as String,
      nicfront: json['nicfront'] as String,
      nicback: json['nicback'] as String,
      address: json['address'] as String,
      roleid: json['roleid'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'stunumber': instance.stunumber,
      'email': instance.email,
      'fname': instance.fname,
      'lname': instance.lname,
      'phone': instance.phone,
      'homenumber': instance.homenumber,
      'image': instance.image,
      'token': instance.token,
      'signature': instance.signature,
      'nicfront': instance.nicfront,
      'nicback': instance.nicback,
      'address': instance.address,
      'roleid': instance.roleid,
      'status': instance.status,
    };

ZomLinkModel _$ZomLinkModelFromJson(Map<String, dynamic> json) => ZomLinkModel(
      group_id: json['group_id'] as String,
      zoom_links: json['zoom_links'] as List<dynamic>,
    );

Map<String, dynamic> _$ZomLinkModelToJson(ZomLinkModel instance) =>
    <String, dynamic>{
      'group_id': instance.group_id,
      'zoom_links': instance.zoom_links,
    };

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) =>
    ConversationModel(
      id: json['id'] as String,
      conversation_name: json['conversation_name'] as String,
      image: json['image'] as String,
      users: json['users'] as List<dynamic>,
      userArray: (json['userArray'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessageSender: json['lastMessageSender'] as String,
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: json['lastMessageTime'] as String,
      createdBy: json['createdBy'] as String,
      description: json['description'] as String,
      status: json['status'] as int,
    );

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_name': instance.conversation_name,
      'image': instance.image,
      'users': instance.users,
      'userArray': instance.userArray.map((e) => e.toJson()).toList(),
      'lastMessageSender': instance.lastMessageSender,
      'lastMessage': instance.lastMessage,
      'lastMessageTime': instance.lastMessageTime,
      'createdBy': instance.createdBy,
      'description': instance.description,
      'status': instance.status,
    };

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      json['id'] as String,
      json['sendarName'] as String,
      json['senderid'] as String,
      json['image'] as String,
      json['message'] as String,
      json['messageUrl'] as String,
      json['messageType'] as String,
      json['messageTime'] as String,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sendarName': instance.sendarName,
      'senderid': instance.senderid,
      'image': instance.image,
      'message': instance.message,
      'messageUrl': instance.messageUrl,
      'messageType': instance.messageType,
      'messageTime': instance.messageTime,
    };

VideoModel _$VideoModelFromJson(Map<String, dynamic> json) => VideoModel(
      Duration: json['Duration'] as String,
      Fee: json['Fee'] as String,
      VideoName: json['VideoName'] as String,
      corseid: json['corse_id'] as String,
      coursename: json['course_name'] as String,
      image: json['image'] as String,
      vid: json['vid'] as String,
    );

Map<String, dynamic> _$VideoModelToJson(VideoModel instance) =>
    <String, dynamic>{
      'Duration': instance.Duration,
      'Fee': instance.Fee,
      'VideoName': instance.VideoName,
      'corse_id': instance.corseid,
      'course_name': instance.coursename,
      'image': instance.image,
      'vid': instance.vid,
    };

VideosModel _$VideosModelFromJson(Map<String, dynamic> json) => VideosModel(
      Duration: json['Duration'] as String,
      Fee: json['Fee'] as String,
      VideoName: json['VideoName'] as String,
      corseid: json['corse_id'] as String,
      coursename: json['course_name'] as String,
      id: json['id'] as String,
      image: json['image'] as String,
      status: json['status'] as int,
      vurl: json['vurl'] as String,
    );

Map<String, dynamic> _$VideosModelToJson(VideosModel instance) =>
    <String, dynamic>{
      'Duration': instance.Duration,
      'Fee': instance.Fee,
      'VideoName': instance.VideoName,
      'corse_id': instance.corseid,
      'course_name': instance.coursename,
      'id': instance.id,
      'image': instance.image,
      'status': instance.status,
      'vurl': instance.vurl,
    };
