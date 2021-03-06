// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: login.proto

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

GPB_ENUM_FWD_DECLARE(Error);

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum UserType

typedef GPB_ENUM(UserType) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  UserType_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /** 普通用户 */
  UserType_UtNone = 0,

  /** 普通客服 */
  UserType_UtKefu = 1,

  /** 超级客服 */
  UserType_UtSuperKefu = 2,

  /** 管理员 */
  UserType_UtAdmin = 3,

  /** 盈商 */
  UserType_UtBusAdmin = 4,

  /** 盈商客服 */
  UserType_UtBusAdminKefu = 5,

  /** 其它 */
  UserType_UtOther = 6,
};

GPBEnumDescriptor *UserType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL UserType_IsValidValue(int32_t value);

#pragma mark - Enum CLogin_DeviceType

typedef GPB_ENUM(CLogin_DeviceType) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  CLogin_DeviceType_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  CLogin_DeviceType_None = 0,
  CLogin_DeviceType_Android = 1,
  CLogin_DeviceType_Ios = 2,
  CLogin_DeviceType_Web = 3,
};

GPBEnumDescriptor *CLogin_DeviceType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL CLogin_DeviceType_IsValidValue(int32_t value);

#pragma mark - Enum SKickOut_Type

typedef GPB_ENUM(SKickOut_Type) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  SKickOut_Type_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /** 重复登录 */
  SKickOut_Type_ReLogin = 0,

  /** 系统踢人 */
  SKickOut_Type_System = 1,

  /** 超过同IP连接数 */
  SKickOut_Type_SameIpLimit = 2,
};

GPBEnumDescriptor *SKickOut_Type_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL SKickOut_Type_IsValidValue(int32_t value);

#pragma mark - LoginRoot

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
@interface LoginRoot : GPBRootObject
@end

#pragma mark - CLogin

typedef GPB_ENUM(CLogin_FieldNumber) {
  CLogin_FieldNumber_UserId = 1,
  CLogin_FieldNumber_HTTPToken = 2,
  CLogin_FieldNumber_DeviceType = 3,
  CLogin_FieldNumber_UserType = 4,
};

/**
 * 登录
 **/
@interface CLogin : GPBMessage

/** 用户ID */
@property(nonatomic, readwrite) uint64_t userId;

/** HTTP登录的Token */
@property(nonatomic, readwrite, copy, null_resettable) NSString *HTTPToken;

/** 设备类型 */
@property(nonatomic, readwrite) CLogin_DeviceType deviceType;

/** 用户类型 */
@property(nonatomic, readwrite) UserType userType;

@end

/**
 * Fetches the raw value of a @c CLogin's @c deviceType property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t CLogin_DeviceType_RawValue(CLogin *message);
/**
 * Sets the raw value of an @c CLogin's @c deviceType property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetCLogin_DeviceType_RawValue(CLogin *message, int32_t value);

/**
 * Fetches the raw value of a @c CLogin's @c userType property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t CLogin_UserType_RawValue(CLogin *message);
/**
 * Sets the raw value of an @c CLogin's @c userType property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetCLogin_UserType_RawValue(CLogin *message, int32_t value);

#pragma mark - SLogin

typedef GPB_ENUM(SLogin_FieldNumber) {
  SLogin_FieldNumber_Result = 1,
  SLogin_FieldNumber_ErrMsg = 2,
};

@interface SLogin : GPBMessage

/** 错误状态 */
@property(nonatomic, readwrite) enum Error result;

/** 错误内容 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *errMsg;

@end

/**
 * Fetches the raw value of a @c SLogin's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SLogin_Result_RawValue(SLogin *message);
/**
 * Sets the raw value of an @c SLogin's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSLogin_Result_RawValue(SLogin *message, int32_t value);

#pragma mark - SAgainLogin

typedef GPB_ENUM(SAgainLogin_FieldNumber) {
  SAgainLogin_FieldNumber_Result = 1,
  SAgainLogin_FieldNumber_ErrMsg = 2,
};

/**
 * 重新登录
 **/
@interface SAgainLogin : GPBMessage

/** 错误状态 */
@property(nonatomic, readwrite) enum Error result;

/** 错误内容 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *errMsg;

@end

/**
 * Fetches the raw value of a @c SAgainLogin's @c result property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SAgainLogin_Result_RawValue(SAgainLogin *message);
/**
 * Sets the raw value of an @c SAgainLogin's @c result property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSAgainLogin_Result_RawValue(SAgainLogin *message, int32_t value);

#pragma mark - SKickOut

typedef GPB_ENUM(SKickOut_FieldNumber) {
  SKickOut_FieldNumber_UserId = 1,
  SKickOut_FieldNumber_Type = 2,
  SKickOut_FieldNumber_Msg = 3,
};

/**
 * 踢人
 **/
@interface SKickOut : GPBMessage

/** 用户ID */
@property(nonatomic, readwrite) uint64_t userId;

@property(nonatomic, readwrite) SKickOut_Type type;

/** 被踢的原因 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *msg;

@end

/**
 * Fetches the raw value of a @c SKickOut's @c type property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t SKickOut_Type_RawValue(SKickOut *message);
/**
 * Sets the raw value of an @c SKickOut's @c type property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetSKickOut_Type_RawValue(SKickOut *message, int32_t value);

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
