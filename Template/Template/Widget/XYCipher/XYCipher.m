//
//  XYCipher.m
//  XYWidget
//
//  Created by nevsee on 2021/10/25.
//

#import "XYCipher.h"
#import <CommonCrypto/CommonCrypto.h>
#import <Security/Security.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation XYCipher

+ (NSData *)_transformData:(id)aData {
    NSData *data = nil;
    if ([aData isKindOfClass:NSString.class]) {
        data = [aData dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([aData isKindOfClass:NSData.class]) {
        data = aData;
    }
    return data;
}

#pragma mark Base64

+ (NSData *)base64EncodedDataForData:(id)aData options:(NSDataBase64EncodingOptions)options {
    NSData *data = [self _transformData:aData];
    if (!data) return nil;
    return [data base64EncodedDataWithOptions:options];
}

+ (NSString *)base64EncodedStringForData:(id)aData options:(NSDataBase64EncodingOptions)options {
    NSData *data = [self _transformData:aData];
    if (!data) return nil;
    return [data base64EncodedStringWithOptions:options];
}

+ (NSData *)base64DecodeData:(id)aData options:(NSDataBase64DecodingOptions)options {
    if ([aData isKindOfClass:NSData.class]) {
        return [[NSData alloc] initWithBase64EncodedData:aData options:options];
    } else if ([aData isKindOfClass:NSString.class]) {
        return [[NSData alloc] initWithBase64EncodedString:aData options:options];
    } else {
        return nil;
    }
}

#pragma mark MD5

+ (NSData *)md5HashedDataForData:(id)aData {
    NSData *data = [self _transformData:aData];
    if (!data) return nil;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

+ (NSString *)md5HashedStringForData:(id)aData {
    NSData *data = [self _transformData:aData];
    if (!data) return nil;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    NSString *format = @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x";
    return [NSString stringWithFormat:format,
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
    ];
}

#pragma mark AES256

+ (NSData *)aes256EncryptData:(id)aData key:(id)aKey iv:(nullable id)anIv {
    NSData *data = [self _transformData:aData];
    NSData *key = [self _transformData:aKey];
    NSData *iv = [self _transformData:anIv];
    if (!data) return nil;
    if (key.length != 16 && key.length != 24 && key.length != 32) return nil;
    if (iv.length != 16 && iv.length != 0) return nil;
    
    NSData *result = nil;
    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    if (!buffer) return nil;
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          key.bytes,
                                          key.length,
                                          iv.bytes,
                                          data.bytes,
                                          data.length,
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc]initWithBytes:buffer length:encryptedSize];
        free(buffer);
        return result;
    } else {
        free(buffer);
        return nil;
    }
}

+ (NSData *)aes256DecryptData:(NSData *)aData key:(id)aKey iv:(nullable id)anIv {
    NSData *data = [self _transformData:aData];
    NSData *key = [self _transformData:aKey];
    NSData *iv = [self _transformData:anIv];
    if (!data) return nil;
    if (key.length != 16 && key.length != 24 && key.length != 32) return nil;
    if (iv.length != 16 && iv.length != 0) return nil;
    
    NSData *result = nil;
    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    if (!buffer) return nil;
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          key.bytes,
                                          key.length,
                                          iv.bytes,
                                          data.bytes,
                                          data.length,
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc]initWithBytes:buffer length:encryptedSize];
        free(buffer);
        return result;
    } else {
        free(buffer);
        return nil;
    }
}

#pragma mark RSA

+ (NSData *)rsaEncryptData:(id)aData publicKey:(NSString *)key {
    if (!key) return nil;
    SecKeyRef keyRef = [self _rsaCreatePublicKeyRef:key];
    if(!keyRef) return nil;
    NSData *data = [self _transformData:aData];
    if (!data) return nil;
    return [self _rsaEncryptData:data keyRef:keyRef];
}

+ (NSData *)rsaEncryptData:(id)aData privateKey:(NSString *)key {
    if (!key) return nil;
    SecKeyRef keyRef = [self _rsaCreatePrivateKeyRef:key];
    if(!keyRef) return nil;
    NSData *data = [self _transformData:aData];
    if (!data) return nil;
    return [self _rsaEncryptData:data keyRef:keyRef];
}

+ (NSData *)rsaDecryptData:(NSData *)aData publicKey:(NSString *)key {
    if (!key) return nil;
    SecKeyRef keyRef = [self _rsaCreatePublicKeyRef:key];
    if(!keyRef) return nil;
    NSData *data = [self _transformData:aData];
    if (!data) return nil;
    return [self _rsaDecryptData:data keyRef:keyRef];
}

+ (NSData *)rsaDecryptData:(NSData *)aData privateKey:(NSString *)key {
    if (!key) return nil;
    SecKeyRef keyRef = [self _rsaCreatePrivateKeyRef:key];
    if(!keyRef) return nil;
    NSData *data = [self _transformData:aData];
    if (!data) return nil;
    return [self _rsaDecryptData:data keyRef:keyRef];
}

+ (SecKeyRef)_rsaCreatePublicKeyRef:(NSString *)key {
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    if (key.length == 0) return nil;
    
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    keyData = [self _rsaStripPublicKeyHeader:keyData];
    if (!keyData) return nil;
    
    // A tag to read/write keychain storage
    NSString *tag = @"rsa_public_key";
    NSData *tagData = [NSData dataWithBytes:tag.UTF8String length:tag.length];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:tagData forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:keyData forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id)kSecAttrKeyClassPublic forKey:(__bridge id)kSecAttrKeyClass];
    [publicKey setObject:@(YES) forKey:(__bridge id)kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey) CFRelease(persistKey);
    if ((status != noErr) && (status != errSecDuplicateItem)) return nil;
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:@(YES) forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if (status != noErr) return nil;
    return keyRef;
}

+ (SecKeyRef)_rsaCreatePrivateKeyRef:(NSString *)key {
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    if (key.length == 0) return nil;
    
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    keyData = [self _rsaStripPrivateKeyHeader:keyData];
    if (!keyData) return nil;
    
    // A tag to read/write keychain storage
    NSString *tag = @"rsa_private_key";
    NSData *tagData = [NSData dataWithBytes:tag.UTF8String length:tag.length];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:tagData forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);
    
    // Add persistent version of the key to system keychain
    [privateKey setObject:keyData forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)kSecAttrKeyClass];
    [privateKey setObject:@(YES) forKey:(__bridge id)kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil) CFRelease(persistKey);
    if ((status != noErr) && (status != errSecDuplicateItem)) return nil;
    
    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:@(YES) forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if (status != noErr) return nil;
    return keyRef;
}

+ (NSData *)_rsaStripPublicKeyHeader:(NSData *)keyData {
    if (!keyData) return nil;
    
    unsigned long length = [keyData length];
    if (length == 0) return nil;
    
    unsigned char *keyChar = (unsigned char *)[keyData bytes];
    unsigned int index = 0;
    
    if (keyChar[index++] != 0x30) return nil;
    
    if (keyChar[index] > 0x80) index += keyChar[index] - 0x80 + 1;
    else index++;
    
    static unsigned char seqiod[] = {
        0x30, 0x0d, 0x06, 0x09, 0x2a,
        0x86, 0x48, 0x86, 0xf7, 0x0d,
        0x01, 0x01, 0x01, 0x05, 0x00
    };
    if (memcmp(&keyChar[index], seqiod, 15)) return nil;
    
    index += 15;
    
    if (keyChar[index++] != 0x03) return nil;
    
    if (keyChar[index] > 0x80) index += keyChar[index] - 0x80 + 1;
    else index++;
    
    if (keyChar[index++] != '\0') return nil;
    
    return [NSData dataWithBytes:&keyChar[index] length:length - index];
}


+ (NSData *)_rsaStripPrivateKeyHeader:(NSData *)keyData {
    if (!keyData) return nil;
    
    unsigned long length = [keyData length];
    if (!length) return(nil);
    
    unsigned char *keyChar = (unsigned char *)[keyData bytes];
    unsigned int index = 22;
    
    if (0x04 != keyChar[index++]) return nil;
    
    unsigned int lengthChar = keyChar[index++];
    int det = lengthChar & 0x80;
    if (!det) {
        lengthChar = lengthChar & 0x7f;
    } else {
        int byteCount = lengthChar & 0x7f;
        if (byteCount + index > length) return nil;
        unsigned int accum = 0;
        unsigned char *ptr = &keyChar[index];
        index += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        lengthChar = accum;
    }

    return [keyData subdataWithRange:NSMakeRange(index, lengthChar)];
}

+ (NSData *)_rsaEncryptData:(NSData *)data keyRef:(SecKeyRef)keyRef {
    const uint8_t *sourceBuffer = (const uint8_t *)[data bytes];
    size_t sourceLength = (size_t)data.length;
    
    size_t blockSize = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outBuffer = malloc(blockSize);
    size_t sourceBlockSize = blockSize - 11;
    
    NSMutableData *result = [[NSMutableData alloc] init];
    for (int index = 0; index < sourceLength; index += sourceBlockSize) {
        size_t dataLength = sourceLength - index;
        if (dataLength > sourceBlockSize) {
            dataLength = sourceBlockSize;
        }
        size_t outLength = blockSize;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef, kSecPaddingPKCS1, sourceBuffer + index, dataLength, outBuffer, &outLength);
        if (status != 0) {
            result = nil;
            break;
        } else {
            [result appendBytes:outBuffer length:outLength];
        }
    }
    free(outBuffer);
    CFRelease(keyRef);
    
    return result.copy;
}

+ (NSData *)_rsaDecryptData:(NSData *)data keyRef:(SecKeyRef)keyRef {
    const uint8_t *sourceBuffer = (const uint8_t *)[data bytes];
    size_t sourceLength = (size_t)data.length;
    
    size_t blockSize = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outBuffer = malloc(blockSize);
    size_t sourceBlockSize = blockSize;
    
    NSMutableData *result = [[NSMutableData alloc] init];
    for (int index = 0; index < sourceLength; index += sourceBlockSize){
        size_t dataLength = sourceLength - index;
        if (dataLength > sourceBlockSize){
            dataLength = sourceBlockSize;
        }
        size_t outLength = blockSize;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef, kSecPaddingNone, sourceBuffer + index, dataLength, outBuffer, &outLength);
        if (status != 0) {
            result = nil;
            break;
        } else {
            int indexFirstZero = -1;
            int indexNextZero = (int)outLength;
            for (int i = 0; i < outLength; i++) {
                if (outBuffer[i] == 0) {
                    if (indexFirstZero < 0) {
                        indexFirstZero = i;
                    } else {
                        indexNextZero = i;
                        break;
                    }
                }
            }
            [result appendBytes:&outBuffer[indexFirstZero + 1] length:indexNextZero - indexFirstZero - 1];
        }
    }
    free(outBuffer);
    CFRelease(keyRef);
    
    return result.copy;
}

@end

#pragma clang diagnostic pop
