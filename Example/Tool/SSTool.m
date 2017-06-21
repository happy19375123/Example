//
//  SSTool.m
//  Example
//
//  Created by 张鹏 on 15/11/13.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import "SSTool.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation SSTool


/**
 数字转汉字

 @param arebic 阿拉伯数字

 @return 汉字
 */
+(NSString *)translation:(NSString *)arebic{
    NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    NSLog(@"%@",str);
    NSLog(@"%@",chinese);
    return chinese;
}

+(NSString *)AFBase64EncodedStringFromString:(NSString *)string {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

+(NSString *)AESEncryptWith256Key:(NSString *)string encryptKey:(NSString *)key iv:(NSString *)iv{
    char keyPtr[kCCKeySizeAES256+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus result = CCCryptorCreateWithMode(kCCEncrypt,
                                                     kCCModeCFB8,
                                                     kCCAlgorithmAES128,
                                                     ccNoPadding,
                                                     ivPtr,
                                                     keyPtr,
                                                     kCCKeySizeAES256,
                                                     NULL,
                                                     0,
                                                     0,
                                                     0,
                                                     &cryptor);
    if (result != kCCSuccess) {
        NSLog(@"encryptAESCTRData: createWithMode error: %@", @(result));
        result = CCCryptorRelease(cryptor);
        return nil;
    }
    size_t bufferLength = CCCryptorGetOutputLength(cryptor, [data length], true);
    NSMutableData *buffer = [NSMutableData dataWithLength:bufferLength];
    NSMutableData *cipherData = [NSMutableData data];
    size_t outLength = 0;
    size_t bytesTotal = 0;
    result = CCCryptorUpdate(cryptor,
                             [data bytes],
                             [data length],
                             [buffer mutableBytes],
                             [buffer length],
                             &outLength);
    if (result != kCCSuccess) {
        NSLog(@"encryptAESCTRData: CCCryptorUpdate error: %@", @(result));
        result = CCCryptorRelease(cryptor);
        return nil;
    }
    bytesTotal += outLength;
    size_t remainingBytes = 0;
    remainingBytes = bufferLength;
    remainingBytes -= outLength;
    result = CCCryptorFinal(cryptor,
                            [buffer mutableBytes],
                            remainingBytes,
                            &outLength);
    if (result != kCCSuccess) {
        NSLog(@"encryptAESCTRData: CCCryptorFinal error: %@", @(result));
        result = CCCryptorRelease(cryptor);
        return nil;
    }
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    [cipherData appendData:ivData];
    bytesTotal += outLength;
    [cipherData appendBytes:buffer.bytes length:bytesTotal];
    CCCryptorRelease(cryptor);
    return [cipherData base64EncodedStringWithOptions:0];
//    return [[NSString alloc] initWithData:cipherData encoding:NSUTF8StringEncoding];
}
@end
