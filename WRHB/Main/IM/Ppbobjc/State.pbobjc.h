// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: state.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class UserState;
GPB_ENUM_FWD_DECLARE(Error);

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum State

typedef GPB_ENUM(State) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  State_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /** 手机离线 */
  State_Offline = 0,

  /** 手机在线 */
  State_Online = 1,

  /** 手机退到后台 */
  State_Background = 2,
};

GPBEnumDescriptor *State_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL State_IsValidValue(int32_t value);

#pragma mark - StateRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface StateRoot : GPBRootObject
@end

#pragma mark - UserState

typedef GPB_ENUM(UserState_FieldNumber) {
  UserState_FieldNumber_UserId = 1,
  UserState_FieldNumber_State = 2,
  UserState_FieldNumber_OfflineTime = 3,
};

@interface UserState : GPBMessage

/** 用户ID */
@property(nonatomic, readwrite) uint64_t userId;

/** 用户状态 */
@property(nonatomic, readwrite) State state;

/** 离线时间 */
@property(nonatomic, readwrite) int64_t offlineTime;

@end

/**
 * Fetches the raw value of a @c UserState's @c state property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t UserState_State_RawValue(UserState *message);
/**
 * Sets the raw value of an @c UserState's @c state property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetUserState_State_RawValue(UserState *message, int32_t value);

#pragma mark - CStateUser

typedef GPB_ENUM(CStateUser_FieldNumber) {
  CStateUser_FieldNumber_UserIdArray = 1,
};

/**
 * 获取用户状态
 **/
@interface CStateUser : GPBMessage

/** 用户ID */
@property(nonatomic, readwrite, strong, null_resettable) GPBUInt64Array *userIdArray;
/** The number of items in @c userIdArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger userIdArray_Count;

@end

#pragma mark - SStateUser

typedef GPB_ENUM(SStateUser_FieldNumber) {
  SStateUser_FieldNumber_Result = 1,
  SStateUser_FieldNumber_UserStateArray = 2,
};

@interface SStateUser : GPBMessage

@property(nonatomic, readwrite) enum Error result;

/** 用户状态 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<UserState*> *userStateArray;
/** The number of items in @c userStateArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger userStateArray_Count;

@end

/**
 * Fetches the raw value of a @c SStateUser's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SStateUser_Result_RawValue(SStateUser *message);
/**
 * Sets the raw value of an @c SStateUser's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSStateUser_Result_RawValue(SStateUser *message, int32_t value);

#pragma mark - CSetUserState

typedef GPB_ENUM(CSetUserState_FieldNumber) {
  CSetUserState_FieldNumber_State = 1,
};

/**
 * 设置用户状态
 **/
@interface CSetUserState : GPBMessage

/** 自已的状态 */
@property(nonatomic, readwrite) State state;

@end

/**
 * Fetches the raw value of a @c CSetUserState's @c state property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t CSetUserState_State_RawValue(CSetUserState *message);
/**
 * Sets the raw value of an @c CSetUserState's @c state property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetCSetUserState_State_RawValue(CSetUserState *message, int32_t value);

#pragma mark - SSetUserState

typedef GPB_ENUM(SSetUserState_FieldNumber) {
  SSetUserState_FieldNumber_Result = 1,
};

@interface SSetUserState : GPBMessage

@property(nonatomic, readwrite) enum Error result;

@end

/**
 * Fetches the raw value of a @c SSetUserState's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SSetUserState_Result_RawValue(SSetUserState *message);
/**
 * Sets the raw value of an @c SSetUserState's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSSetUserState_Result_RawValue(SSetUserState *message, int32_t value);

#pragma mark - SNotifyStateChange

typedef GPB_ENUM(SNotifyStateChange_FieldNumber) {
  SNotifyStateChange_FieldNumber_UserStateArray = 2,
};

/**
 * 状态改变自动推送
 **/
@interface SNotifyStateChange : GPBMessage

/** 用户状态 */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<UserState*> *userStateArray;
/** The number of items in @c userStateArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger userStateArray_Count;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
