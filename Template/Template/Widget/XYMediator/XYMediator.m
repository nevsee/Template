//
//  XYMediator.m
//  XYMediator
//
//  Created by nevsee on 2021/1/15.
//

#import "XYMediator.h"
#import <objc/runtime.h>
#import <CoreGraphics/CoreGraphics.h>

// Error domain
NSErrorDomain const XYMediatorIllegalURLErrorDomain = @"XYMediatorIllegalURLErrorDomain";
NSErrorDomain const XYMediatorExcessArgumentErrorDomain = @"XYMediatorExcessArgumentErrorDomain";
NSErrorDomain const XYMediatorNoTargetErrorDomain = @"XYMediatorNoTargetErrorDomain";
NSErrorDomain const XYMediatorNoActionErrorDomain = @"XYMediatorNoActionErrorDomain";
NSErrorDomain const XYMediatorUnsupportedReturnTypeErrorDomain = @"XYMediatorUnsupportedReturnTypeErrorDomain";

// Error key
NSErrorUserInfoKey const XYMediatorErrorKey= @"XYMediatorErrorKey";

// Encoding type
typedef NS_ENUM(NSUInteger, XYEncodingType) {
    XYEncodingTypeUnknown    = 0, // unknown
    XYEncodingTypeVoid       = 1, // void
    XYEncodingTypeBool       = 2, // bool
    XYEncodingTypeInt8       = 3, // char / BOOL
    XYEncodingTypeUInt8      = 4, // unsigned char
    XYEncodingTypeInt16      = 5, // short
    XYEncodingTypeUInt16     = 6, // unsigned short
    XYEncodingTypeInt32      = 7, // int
    XYEncodingTypeUInt32     = 8, // unsigned int
    XYEncodingTypeInt64      = 9, // long long
    XYEncodingTypeUInt64     = 10, // unsigned long long
    XYEncodingTypeFloat      = 11, // float
    XYEncodingTypeDouble     = 12, // double
    XYEncodingTypeLongDouble = 13, // long double
    XYEncodingTypeObject     = 14, // id
    XYEncodingTypeClass      = 15, // Class
    XYEncodingTypeSEL        = 16, // SEL
    XYEncodingTypeBlock      = 17, // block
    XYEncodingTypePointer    = 18, // void*
    XYEncodingTypeStruct     = 19, // struct
    XYEncodingTypeUnion      = 20, // union
    XYEncodingTypeCString    = 21, // char*
    XYEncodingTypeCArray     = 22, // char[]
};

XYEncodingType XYEncodingGetType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) return XYEncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return XYEncodingTypeUnknown;

    switch (*type) {
        case 'v': return XYEncodingTypeVoid;
        case 'B': return XYEncodingTypeBool;
        case 'c': return XYEncodingTypeInt8;
        case 'C': return XYEncodingTypeUInt8;
        case 's': return XYEncodingTypeInt16;
        case 'S': return XYEncodingTypeUInt16;
        case 'i': return XYEncodingTypeInt32;
        case 'I': return XYEncodingTypeUInt32;
        case 'l': return XYEncodingTypeInt32;
        case 'L': return XYEncodingTypeUInt32;
        case 'q': return XYEncodingTypeInt64;
        case 'Q': return XYEncodingTypeUInt64;
        case 'f': return XYEncodingTypeFloat;
        case 'd': return XYEncodingTypeDouble;
        case 'D': return XYEncodingTypeLongDouble;
        case '#': return XYEncodingTypeClass;
        case ':': return XYEncodingTypeSEL;
        case '*': return XYEncodingTypeCString;
        case '^': return XYEncodingTypePointer;
        case '[': return XYEncodingTypeCArray;
        case '(': return XYEncodingTypeUnion;
        case '{': return XYEncodingTypeStruct;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return XYEncodingTypeBlock;
            else
                return XYEncodingTypeObject;
        }
        default: return XYEncodingTypeUnknown;
    }
}

#define XYInvokeMethod(stuff) \
    do { \
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];\
        if (argumentsCount == 1) [invocation setArgument:&param atIndex:2];\
        [invocation setSelector:action];\
        [invocation setTarget:target];\
        [invocation invoke];\
        stuff\
    } while (0)


@interface XYMediator ()
@property (nonatomic, strong) id urlValidator;
@property (nonatomic, strong) id errorProcessor;
@end

@implementation XYMediator

#pragma mark # Life

+ (instancetype)defaultMediator {
    static XYMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[super allocWithZone:NULL] init];
    });
    return mediator;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [XYMediator defaultMediator] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [XYMediator defaultMediator];
}

#pragma mark # Public

+ (void)registerURLValidator:(id<XYSafetyURLValidator>)validator {
    if (![validator respondsToSelector:@selector(validateUrl:)]) return;
    XYMediator *mediator = [XYMediator defaultMediator];
    mediator.urlValidator = validator;
}

+ (void)registerErrorProcessor:(id<XYErrorProcessor>)processor {
    if (![processor respondsToSelector:@selector(processError:)]) return;
    XYMediator *mediator = [XYMediator defaultMediator];
    mediator.errorProcessor = processor;
}

- (id)performActionWithUrl:(NSURL *)url {
    // validate url
    if (_urlValidator && [_urlValidator respondsToSelector:@selector(validateUrl:)]) {
        url = [_urlValidator validateUrl:url];
        if (!url) {
            return [self errorWithDomain:XYMediatorIllegalURLErrorDomain];
        }
    }
    
    // parse url
    NSString *query = url.query;
    NSString *host = url.host;
    NSString *path = url.path;
    
    // target name
    NSString *targetName = host;

    // action name
    NSString *actionName = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    // parameter
    NSDictionary *params = nil;
    if (query) {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
        NSArray *kvs = [query componentsSeparatedByString:@"&"];
        
        for (NSString *kv in kvs) {
            NSArray *elts = [kv componentsSeparatedByString:@"="];
            if(elts.count < 2) continue;
            [temp setObject:elts.lastObject forKey:elts.firstObject];
        }
        if (temp.allKeys > 0) params = temp.copy;
    }
    
    return [self performAction:actionName forTarget:targetName withParam:params];
}

- (id)performAction:(NSString *)actionName forTarget:(NSString *)targetName withParam:(NSDictionary *)param {
    if (!targetName || !actionName) return nil;
    
    // get object
    Class targetClass = NSClassFromString(targetName);
    id targetObject = [[targetClass alloc] init];
    
    if (!targetObject) {
        return [self errorWithDomain:XYMediatorNoTargetErrorDomain];
    }

    // get selector
    if (param) {
        actionName = [actionName stringByAppendingString:@":"];
    }
    SEL targetAction = NSSelectorFromString(actionName);
    
    // perform selector
    if ([targetObject respondsToSelector:targetAction]) {
        return [self invokeAction:targetAction forTarget:targetObject withParam:param];
    } else {
        return [self errorWithDomain:XYMediatorNoActionErrorDomain];
    }
}

#pragma mark # Private

- (id)invokeAction:(SEL)action forTarget:(NSObject *)target withParam:(NSDictionary *)param {
    // get method signature
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:action];
 
    // get the number of method parameters (sendMessage(id, SEL, ..))
    NSUInteger argumentsCount = methodSignature.numberOfArguments - 2;
    if (argumentsCount > 1) return [self errorWithDomain:XYMediatorExcessArgumentErrorDomain];
    
    // get method return type
    XYEncodingType returnType = XYEncodingGetType([methodSignature methodReturnType]);
    
    // invoke method
    // return type such as struct/union/char[] is not supported
    switch (returnType) {
        // void -> nil
        case XYEncodingTypeVoid:
            XYInvokeMethod(return nil;);

        // BOOL -> NSNumber
        case XYEncodingTypeBool:
            XYInvokeMethod(BOOL value; [invocation getReturnValue:&value]; return @(value););

        // NSInteger -> NSNumber
        case XYEncodingTypeInt8:
        case XYEncodingTypeInt16:
        case XYEncodingTypeInt32:
        case XYEncodingTypeInt64:
            XYInvokeMethod(NSInteger value; [invocation getReturnValue:&value]; return @(value););

        // NSUInteger -> NSNumber
        case XYEncodingTypeUInt8:
        case XYEncodingTypeUInt16:
        case XYEncodingTypeUInt32:
        case XYEncodingTypeUInt64:
            XYInvokeMethod(NSUInteger value; [invocation getReturnValue:&value]; return @(value););

        // CGFloat -> NSNumber
        case XYEncodingTypeDouble:
        case XYEncodingTypeLongDouble:
        case XYEncodingTypeFloat:
            XYInvokeMethod(CGFloat value; [invocation getReturnValue:&value]; return @(value););

        // Object -> Object
        // Block -> Block
        case XYEncodingTypeBlock:
        case XYEncodingTypeObject:
            XYInvokeMethod(void *temp; [invocation getReturnValue:&temp]; if (!temp) return nil; return (__bridge id)temp;);

        // Class -> Class
        case XYEncodingTypeClass:
            XYInvokeMethod(Class value; [invocation getReturnValue:&value]; return value;);

        // SEL -> NSString
        case XYEncodingTypeSEL:
            XYInvokeMethod(SEL value; [invocation getReturnValue:&value]; return NSStringFromSelector(value););

        // Pointer -> NSValue
        case XYEncodingTypePointer:
            XYInvokeMethod(void *value; [invocation getReturnValue:&value]; return [NSValue valueWithPointer:value];);

        // Char -> NSString
        case XYEncodingTypeCString:
            XYInvokeMethod(char *value; [invocation getReturnValue:&value]; return [NSString stringWithUTF8String:value];);

        // Struct/Union/CArray
        default:
            return [self errorWithDomain:XYMediatorUnsupportedReturnTypeErrorDomain];
    }
}

- (NSError *)errorWithDomain:(NSErrorDomain)domain {
    NSDictionary *notes = @{
        XYMediatorIllegalURLErrorDomain: @"illegal url",
        XYMediatorExcessArgumentErrorDomain: @"too many arguments for the action",
        XYMediatorNoTargetErrorDomain: @"no target",
        XYMediatorNoActionErrorDomain: @"no action",
        XYMediatorUnsupportedReturnTypeErrorDomain: @"unsupported return type",
    };
    
    NSDictionary *userInfo = @{
        XYMediatorErrorKey: notes[domain]
    };
    
    NSError *error = [NSError errorWithDomain:domain code:0 userInfo:userInfo];
    
    if (_errorProcessor && [_errorProcessor respondsToSelector:@selector(processError:)]) {
        [_errorProcessor processError:error];
    }
    
    return error;
}

@end
