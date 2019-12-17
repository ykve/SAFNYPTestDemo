// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: notify.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

#import "Notify.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - NotifyRoot

@implementation NotifyRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - NotifyRoot_FileDescriptor

static GPBFileDescriptor *NotifyRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"fpb"
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - SessionMemberInfo

@implementation SessionMemberInfo

@dynamic userId;
@dynamic name;
@dynamic avatar;

typedef struct SessionMemberInfo__storage_ {
  uint32_t _has_storage_[1];
  NSString *name;
  NSString *avatar;
  uint64_t userId;
} SessionMemberInfo__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = SessionMemberInfo_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SessionMemberInfo__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt64,
      },
      {
        .name = "name",
        .dataTypeSpecific.className = NULL,
        .number = SessionMemberInfo_FieldNumber_Name,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SessionMemberInfo__storage_, name),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "avatar",
        .dataTypeSpecific.className = NULL,
        .number = SessionMemberInfo_FieldNumber_Avatar,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(SessionMemberInfo__storage_, avatar),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SessionMemberInfo class]
                                     rootClass:[NotifyRoot class]
                                          file:NotifyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SessionMemberInfo__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SNotifySessionAdd

@implementation SNotifySessionAdd

@dynamic sessionId;
@dynamic sessionVer;
@dynamic name;
@dynamic desc;
@dynamic avatar;
@dynamic playType;
@dynamic numberLimit;
@dynamic type;
@dynamic packetRange;
@dynamic membersArray, membersArray_Count;

typedef struct SNotifySessionAdd__storage_ {
  uint32_t _has_storage_[1];
  uint32_t sessionVer;
  int32_t playType;
  int32_t type;
  NSString *name;
  NSString *desc;
  NSString *avatar;
  NSString *numberLimit;
  NSString *packetRange;
  NSMutableArray *membersArray;
  uint64_t sessionId;
} SNotifySessionAdd__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "sessionId",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionAdd_FieldNumber_SessionId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SNotifySessionAdd__storage_, sessionId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt64,
      },
      {
        .name = "sessionVer",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionAdd_FieldNumber_SessionVer,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SNotifySessionAdd__storage_, sessionVer),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt32,
      },
      {
        .name = "name",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionAdd_FieldNumber_Name,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(SNotifySessionAdd__storage_, name),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "desc",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionAdd_FieldNumber_Desc,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(SNotifySessionAdd__storage_, desc),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "avatar",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionAdd_FieldNumber_Avatar,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(SNotifySessionAdd__storage_, avatar),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "playType",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionAdd_FieldNumber_PlayType,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(SNotifySessionAdd__storage_, playType),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "numberLimit",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionAdd_FieldNumber_NumberLimit,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(SNotifySessionAdd__storage_, numberLimit),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "type",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionAdd_FieldNumber_Type,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(SNotifySessionAdd__storage_, type),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "packetRange",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionAdd_FieldNumber_PacketRange,
        .hasIndex = 8,
        .offset = (uint32_t)offsetof(SNotifySessionAdd__storage_, packetRange),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "membersArray",
        .dataTypeSpecific.className = GPBStringifySymbol(SessionMemberInfo),
        .number = SNotifySessionAdd_FieldNumber_MembersArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(SNotifySessionAdd__storage_, membersArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SNotifySessionAdd class]
                                     rootClass:[NotifyRoot class]
                                          file:NotifyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SNotifySessionAdd__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SNotifySessionUpdate

@implementation SNotifySessionUpdate

@dynamic sessionId;
@dynamic name;
@dynamic desc;
@dynamic avatar;
@dynamic notice;
@dynamic playType;
@dynamic numberLimit;
@dynamic type;
@dynamic packetRange;

typedef struct SNotifySessionUpdate__storage_ {
  uint32_t _has_storage_[1];
  int32_t playType;
  int32_t type;
  NSString *name;
  NSString *desc;
  NSString *avatar;
  NSString *notice;
  NSString *numberLimit;
  NSString *packetRange;
  uint64_t sessionId;
} SNotifySessionUpdate__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "sessionId",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionUpdate_FieldNumber_SessionId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SNotifySessionUpdate__storage_, sessionId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt64,
      },
      {
        .name = "name",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionUpdate_FieldNumber_Name,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SNotifySessionUpdate__storage_, name),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "desc",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionUpdate_FieldNumber_Desc,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(SNotifySessionUpdate__storage_, desc),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "avatar",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionUpdate_FieldNumber_Avatar,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(SNotifySessionUpdate__storage_, avatar),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "notice",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionUpdate_FieldNumber_Notice,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(SNotifySessionUpdate__storage_, notice),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "playType",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionUpdate_FieldNumber_PlayType,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(SNotifySessionUpdate__storage_, playType),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "numberLimit",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionUpdate_FieldNumber_NumberLimit,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(SNotifySessionUpdate__storage_, numberLimit),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "type",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionUpdate_FieldNumber_Type,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(SNotifySessionUpdate__storage_, type),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "packetRange",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionUpdate_FieldNumber_PacketRange,
        .hasIndex = 8,
        .offset = (uint32_t)offsetof(SNotifySessionUpdate__storage_, packetRange),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SNotifySessionUpdate class]
                                     rootClass:[NotifyRoot class]
                                          file:NotifyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SNotifySessionUpdate__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SNotifySessionDel

@implementation SNotifySessionDel

@dynamic sessionId;

typedef struct SNotifySessionDel__storage_ {
  uint32_t _has_storage_[1];
  uint64_t sessionId;
} SNotifySessionDel__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "sessionId",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionDel_FieldNumber_SessionId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SNotifySessionDel__storage_, sessionId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SNotifySessionDel class]
                                     rootClass:[NotifyRoot class]
                                          file:NotifyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SNotifySessionDel__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SNotifySessionMemberAdd

@implementation SNotifySessionMemberAdd

@dynamic sessionId;
@dynamic addMembersArray, addMembersArray_Count;

typedef struct SNotifySessionMemberAdd__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *addMembersArray;
  uint64_t sessionId;
} SNotifySessionMemberAdd__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "sessionId",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionMemberAdd_FieldNumber_SessionId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SNotifySessionMemberAdd__storage_, sessionId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt64,
      },
      {
        .name = "addMembersArray",
        .dataTypeSpecific.className = GPBStringifySymbol(SessionMemberInfo),
        .number = SNotifySessionMemberAdd_FieldNumber_AddMembersArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(SNotifySessionMemberAdd__storage_, addMembersArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SNotifySessionMemberAdd class]
                                     rootClass:[NotifyRoot class]
                                          file:NotifyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SNotifySessionMemberAdd__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SNotifySessionMemberDel

@implementation SNotifySessionMemberDel

@dynamic sessionId;
@dynamic delIdsArray, delIdsArray_Count;

typedef struct SNotifySessionMemberDel__storage_ {
  uint32_t _has_storage_[1];
  GPBUInt64Array *delIdsArray;
  uint64_t sessionId;
} SNotifySessionMemberDel__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "sessionId",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionMemberDel_FieldNumber_SessionId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SNotifySessionMemberDel__storage_, sessionId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt64,
      },
      {
        .name = "delIdsArray",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionMemberDel_FieldNumber_DelIdsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(SNotifySessionMemberDel__storage_, delIdsArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldPacked),
        .dataType = GPBDataTypeUInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SNotifySessionMemberDel class]
                                     rootClass:[NotifyRoot class]
                                          file:NotifyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SNotifySessionMemberDel__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SNotifyAddFriends

@implementation SNotifyAddFriends

@dynamic type;
@dynamic applicant;
@dynamic respondent;

typedef struct SNotifyAddFriends__storage_ {
  uint32_t _has_storage_[1];
  int32_t type;
  uint64_t applicant;
  uint64_t respondent;
} SNotifyAddFriends__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "type",
        .dataTypeSpecific.className = NULL,
        .number = SNotifyAddFriends_FieldNumber_Type,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SNotifyAddFriends__storage_, type),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "applicant",
        .dataTypeSpecific.className = NULL,
        .number = SNotifyAddFriends_FieldNumber_Applicant,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SNotifyAddFriends__storage_, applicant),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt64,
      },
      {
        .name = "respondent",
        .dataTypeSpecific.className = NULL,
        .number = SNotifyAddFriends_FieldNumber_Respondent,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(SNotifyAddFriends__storage_, respondent),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SNotifyAddFriends class]
                                     rootClass:[NotifyRoot class]
                                          file:NotifyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SNotifyAddFriends__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Announcement

@implementation Announcement

@dynamic id_p;
@dynamic detail;
@dynamic description_p;
@dynamic sort;

typedef struct Announcement__storage_ {
  uint32_t _has_storage_[1];
  int32_t id_p;
  int32_t sort;
  NSString *detail;
  NSString *description_p;
} Announcement__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "id_p",
        .dataTypeSpecific.className = NULL,
        .number = Announcement_FieldNumber_Id_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(Announcement__storage_, id_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "detail",
        .dataTypeSpecific.className = NULL,
        .number = Announcement_FieldNumber_Detail,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(Announcement__storage_, detail),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "description_p",
        .dataTypeSpecific.className = NULL,
        .number = Announcement_FieldNumber_Description_p,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(Announcement__storage_, description_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "sort",
        .dataTypeSpecific.className = NULL,
        .number = Announcement_FieldNumber_Sort,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(Announcement__storage_, sort),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[Announcement class]
                                     rootClass:[NotifyRoot class]
                                          file:NotifyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(Announcement__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SNotifyAnnouncement

@implementation SNotifyAnnouncement

@dynamic infosArray, infosArray_Count;

typedef struct SNotifyAnnouncement__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *infosArray;
} SNotifyAnnouncement__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "infosArray",
        .dataTypeSpecific.className = GPBStringifySymbol(Announcement),
        .number = SNotifyAnnouncement_FieldNumber_InfosArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(SNotifyAnnouncement__storage_, infosArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SNotifyAnnouncement class]
                                     rootClass:[NotifyRoot class]
                                          file:NotifyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SNotifyAnnouncement__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SNotifyUserInfoUpdate

@implementation SNotifyUserInfoUpdate

@dynamic userId;
@dynamic name;
@dynamic avatar;
@dynamic gender;

typedef struct SNotifyUserInfoUpdate__storage_ {
  uint32_t _has_storage_[1];
  int32_t gender;
  NSString *name;
  NSString *avatar;
  uint64_t userId;
} SNotifyUserInfoUpdate__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = SNotifyUserInfoUpdate_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SNotifyUserInfoUpdate__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt64,
      },
      {
        .name = "name",
        .dataTypeSpecific.className = NULL,
        .number = SNotifyUserInfoUpdate_FieldNumber_Name,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SNotifyUserInfoUpdate__storage_, name),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "avatar",
        .dataTypeSpecific.className = NULL,
        .number = SNotifyUserInfoUpdate_FieldNumber_Avatar,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(SNotifyUserInfoUpdate__storage_, avatar),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "gender",
        .dataTypeSpecific.className = NULL,
        .number = SNotifyUserInfoUpdate_FieldNumber_Gender,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(SNotifyUserInfoUpdate__storage_, gender),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SNotifyUserInfoUpdate class]
                                     rootClass:[NotifyRoot class]
                                          file:NotifyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SNotifyUserInfoUpdate__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SNotifySessionMemberInfoUpdate

@implementation SNotifySessionMemberInfoUpdate

@dynamic sessionIdsArray, sessionIdsArray_Count;
@dynamic userId;
@dynamic name;
@dynamic avatar;
@dynamic gender;

typedef struct SNotifySessionMemberInfoUpdate__storage_ {
  uint32_t _has_storage_[1];
  int32_t gender;
  GPBUInt64Array *sessionIdsArray;
  NSString *name;
  NSString *avatar;
  uint64_t userId;
} SNotifySessionMemberInfoUpdate__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "sessionIdsArray",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionMemberInfoUpdate_FieldNumber_SessionIdsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(SNotifySessionMemberInfoUpdate__storage_, sessionIdsArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldPacked),
        .dataType = GPBDataTypeUInt64,
      },
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionMemberInfoUpdate_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SNotifySessionMemberInfoUpdate__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt64,
      },
      {
        .name = "name",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionMemberInfoUpdate_FieldNumber_Name,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SNotifySessionMemberInfoUpdate__storage_, name),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "avatar",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionMemberInfoUpdate_FieldNumber_Avatar,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(SNotifySessionMemberInfoUpdate__storage_, avatar),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "gender",
        .dataTypeSpecific.className = NULL,
        .number = SNotifySessionMemberInfoUpdate_FieldNumber_Gender,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(SNotifySessionMemberInfoUpdate__storage_, gender),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SNotifySessionMemberInfoUpdate class]
                                     rootClass:[NotifyRoot class]
                                          file:NotifyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SNotifySessionMemberInfoUpdate__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - SNotifyPush

@implementation SNotifyPush

@dynamic sender;
@dynamic action;
@dynamic extras;

typedef struct SNotifyPush__storage_ {
  uint32_t _has_storage_[1];
  NSString *action;
  NSString *extras;
  uint64_t sender;
} SNotifyPush__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "sender",
        .dataTypeSpecific.className = NULL,
        .number = SNotifyPush_FieldNumber_Sender,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(SNotifyPush__storage_, sender),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt64,
      },
      {
        .name = "action",
        .dataTypeSpecific.className = NULL,
        .number = SNotifyPush_FieldNumber_Action,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(SNotifyPush__storage_, action),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "extras",
        .dataTypeSpecific.className = NULL,
        .number = SNotifyPush_FieldNumber_Extras,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(SNotifyPush__storage_, extras),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[SNotifyPush class]
                                     rootClass:[NotifyRoot class]
                                          file:NotifyRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(SNotifyPush__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - CNotifyAck

@implementation CNotifyAck


typedef struct CNotifyAck__storage_ {
  uint32_t _has_storage_[1];
} CNotifyAck__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[CNotifyAck class]
                                     rootClass:[NotifyRoot class]
                                          file:NotifyRoot_FileDescriptor()
                                        fields:NULL
                                    fieldCount:0
                                   storageSize:sizeof(CNotifyAck__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
