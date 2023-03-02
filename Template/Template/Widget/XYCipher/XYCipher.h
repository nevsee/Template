//
//  XYCipher.h
//  XYWidget
//
//  Created by nevsee on 2021/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYCipher : NSObject

#pragma mark Encode and decode

///-------------------------------
/// @name base64
///-------------------------------

/**
 Returns a Base-64, UTF-8 encoded NSData from the receiver's contents using the given options.
 @param aData A NSString or a UTF-8 NSData to encode.
 @param options Base-64 encoding Options.
 */
+ (nullable NSData *)base64EncodedDataForData:(id)aData options:(NSDataBase64EncodingOptions)options;

/**
 Returns a Base-64 encoded NSString from the receiver's contents using the given options.
 @param aData A NSString or a UTF-8 NSData to encode.
 @param options Base-64 encoding Options.
 */
+ (nullable NSString *)base64EncodedStringForData:(id)aData options:(NSDataBase64EncodingOptions)options;

/**
 Returns an NSData from a Base-64 encoded NSString or a Base-64, UTF-8 encoded NSData using
 the given options. By default, returns nil when the input is not recognized as valid Base-64.
 @param aData A NSString or a UTF-8 NSData to decode.
 @param options Base-64 decoding Options.
 */
+ (nullable NSData *)base64DecodeData:(id)aData options:(NSDataBase64DecodingOptions)options;

#pragma mark Hash

///-------------------------------
/// @name MD5
///-------------------------------

/**
 Returns an NSData for md5 hash.
 @param aData A NSString or a UTF-8 NSData to hash.
 */
+ (nullable NSData *)md5HashedDataForData:(id)aData;

/**
 Returns a lowercase NSString for md5 hash.
 @param aData A NSString or a UTF-8 NSData to hash.
 */
+ (nullable NSString *)md5HashedStringForData:(id)aData;

#pragma mark Encrypt and Decrypt

///-------------------------------
/// @name AES256
///-------------------------------

/**
 Returns an encrypted data using AES-256.
 @param aData A NSString or a UTF-8 NSData to encrypt.
 @param aKey A key length of 16, 24 or 32 (128, 192 or 256bits).
 @param anIv  An initialization vector length of 16(128bits). Pass nil when you don't want to use iv.
 */
+ (nullable NSData *)aes256EncryptData:(id)aData key:(id)aKey iv:(nullable id)anIv;

/**
 Returns a decrypted data using AES-256.
 @param aData An AES-256 encrypted data.
 @param aKey A key length of 16, 24 or 32 (128, 192 or 256bits).
 @param anIv  An initialization vector length of 16(128bits). Pass nil when you don't want to use iv.
 */
+ (nullable NSData *)aes256DecryptData:(NSData *)aData key:(id)aKey iv:(nullable id)anIv;

///-------------------------------
/// @name RSA
///-------------------------------

/**
 Returns a encrypted data using RSA.
 @param aData A NSString or a UTF-8 NSData to encrypt.
 @param key A public key of base-64 encoded.
 */
+ (nullable NSData *)rsaEncryptData:(id)aData publicKey:(NSString *)key;

/**
 Returns a encrypted data using RSA.
 @param aData A NSString or a UTF-8 NSData to encrypt.
 @param key A private key of base-64 encoded.
 */
+ (nullable NSData *)rsaEncryptData:(id)aData privateKey:(NSString *)key;

/**
 Returns a decrypted data using RSA.
 @param aData A RSA encrypted data.
 @param key A public key of base-64 encoded.
 */
+ (nullable NSData *)rsaDecryptData:(NSData *)aData publicKey:(NSString *)key;

/**
 Returns a decrypted data using RSA.
 @param aData A RSA encrypted data.
 @param key A private key of base-64 encoded.
 */
+ (nullable NSData *)rsaDecryptData:(NSData *)aData privateKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
