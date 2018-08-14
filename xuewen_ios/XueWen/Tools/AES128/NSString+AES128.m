//
//  NSString+AES128.m
//  ceshi
//
//  Created by hushuangfei on 16/7/23.
//  Copyright © 2016年 胡双飞. All rights reserved.
//

#import "NSString+AES128.h"
#import "NSData+AES128.h"
#define gkey			@"ntN8FBcXmxv6EPx0"     // 密钥
#define gIv             @"fba71f1985cb0e39"     // 偏移量
@implementation NSString (AES128)
/** 加密 */
-(NSString *)encrypt{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [data AES128EncryptWithKey:gkey iv:gIv];
    NSString *encryptring =  [encryptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSMutableString *mStr = [NSMutableString stringWithString:encryptring];
    //去掉字符串中的换行
    NSRange range = {0,mStr.length};
    [mStr replaceOccurrencesOfString:@"\r" withString:@"" options:NSLiteralSearch range:range];
    range = NSMakeRange(0, mStr.length);
    [mStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range];
    range =NSMakeRange(0, mStr.length);
    [mStr replaceOccurrencesOfString:@"\r\n" withString:@"" options:NSLiteralSearch range:range];
    return mStr;
}
/** 解密 */
-(NSString *)decrypt{
    NSData *decryptBase64data = [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [decryptBase64data AES128DecryptWithKey:gkey iv:gIv];
    NSString *decryptString = [[NSString alloc]initWithData:decryptData encoding:NSUTF8StringEncoding];
    return decryptString;
}
/** 拼接用于加密的字符串 */
+(NSString *)encryptWithAppType:(NSString *)appType did:(NSString *)did time:(NSString *)time{
    NSString *jsonString = [NSString stringWithFormat:@"{\"type\":\"%@\",\"did\":\"%@\",\"time\":\"%@\"}",appType,did,time];
    return [jsonString encrypt];
}
//加密
+ (NSString *)AES128CBC_PKCS5Padding_EncryptStrig:(NSString *)string keyAndIv:(NSString *)keyAndIv{
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [data AES128EncryptWithKey:keyAndIv iv:keyAndIv];
    NSString *encryptring =  [encryptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encryptring;

}
//加密
+ (NSString *)AES128CBC_PKCS5Padding_EncryptStrig:(NSString *)string key:(NSString*)key iv:(NSString *)iv{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [data AES128EncryptWithKey:key iv:iv];
    NSString *encryptring =  [encryptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encryptring;
    
}
//解密
+ (NSString *)AES128CBC_PKCS5Padding_DecryptString:(NSString *)string keyAndIv:(NSString *)keyAndIv{
    
    NSData *decryptBase64data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [decryptBase64data AES128DecryptWithKey:keyAndIv iv:keyAndIv];
    NSString *decryptString = [[NSString alloc]initWithData:decryptData encoding:NSUTF8StringEncoding];
    return decryptString;
   
}
//解密
+ (NSString *)AES128CBC_PKCS5Padding_DecryptString:(NSString *)string key:(NSString *)key iv:(NSString *)iv{
    
    NSData *decryptBase64data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [decryptBase64data AES128DecryptWithKey:key iv:iv];
    NSString *decryptString = [[NSString alloc]initWithData:decryptData encoding:NSUTF8StringEncoding];
    return decryptString;
    
}

@end
