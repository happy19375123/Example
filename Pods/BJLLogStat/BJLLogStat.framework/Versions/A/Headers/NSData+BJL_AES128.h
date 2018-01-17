// Created by Noah Martin
// http://noahmart.in

#import <Foundation/Foundation.h>

@interface NSData (BJL_AES128)

-(NSData*)bjl_AES128DecryptWithKey:(NSString*)key;

-(NSData*)bjl_AES128EncryptWithKey:(NSString*)key;
@end
