//
//  YYGlobalUtility+Validation.m
//  Template
//
//  Created by nevsee on 2022/1/28.
//

#import "YYGlobalUtility+Validation.h"

@implementation YYGlobalUtility (Validation)

+ (BOOL)validateEmail:(NSString *)email {
    NSString *regExp = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:email];
}

+ (BOOL)validatePhone:(NSString *)phone {
    NSString *regExp = @"^([1][3,4,5,6,7,8,9])[0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:phone];
}

+ (BOOL)validateIdentityCard:(NSString *)identityCard {
    NSString *regExp = @"^(([0-9]{18})|([0-9x]{18})|([0-9X]{18}))$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:identityCard];
}

+ (BOOL)validateHex:(NSString *)hex {
    NSString *regExp = @"^[0-9a-fA-F]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:hex];
}

+ (BOOL)validateLink:(NSString *)link {
    NSString *regExp = @"^((https|http|ftp|rtsp|mms|file)?:\\/\\/)[^\\s]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:link];
}

+ (BOOL)validateInteger:(NSString *)integer {
    NSString *regExp = @"^(0|[1-9][0-9]*)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:integer];
}

+ (BOOL)validateDecimal:(NSString *)decimal {
    NSString *regExp = @"^((0|[1-9][0-9]*)|((0|[1-9][0-9]*)\\.[0-9]+))$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:decimal];
}

+ (BOOL)validateDecimal2:(NSString *)decimal {
    NSString *regExp = @"^((0|[1-9][0-9]*)|((0|[1-9][0-9]*)\\.[0-9]*))$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:decimal];
}

+ (BOOL)validateNumber:(NSString *)number {
    NSString *regExp = @"^[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:number];
}

+ (BOOL)validateCharacter:(NSString *)character {
    NSString *regExp = @"^[a-zA-Z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:character];
}

+ (BOOL)validateNumberAndDot:(NSString *)number {
    NSString *regExp = @"^[0-9\\.]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:number];
}

+ (BOOL)validateNumberAndCharacter:(NSString *)string {
    NSString *regExp = @"^[0-9a-zA-Z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:string];
}

+ (BOOL)validateIntegerInputWithText:(NSString *)text replacementRange:(NSRange)replacementRange replacementString:(NSString *)replacementString {
    BOOL deleteOperation = [replacementString isEqualToString:@""];
    if (deleteOperation) return YES;
    NSString *tempString = [text stringByReplacingCharactersInRange:replacementRange withString:replacementString];
    return [self validateInteger:tempString];
}

+ (BOOL)validateDecimalInputWithText:(NSString *)text replacementRange:(NSRange)replacementRange replacementString:(NSString *)replacementString {
    BOOL deleteOperation = [replacementString isEqualToString:@""];
    if (deleteOperation) return YES;
    NSString *tempString = [text stringByReplacingCharactersInRange:replacementRange withString:replacementString];
    return [self validateDecimal2:tempString];
}

@end
