//
//  FunctionViewController.m
//  Example
//
//  Created by 张鹏 on 15/10/22.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import "FunctionViewController.h"

@interface FunctionViewController ()

@end

@implementation FunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self run];
    [self testRegular];
    [self clearUselessLabel:@""];
    [self testAFBASE64];
    [self testFileSize];
}

-(void)run{
    NSLog(@"run");
    [self RunCFAbsoluteTimeGetCurrent];
}

#pragma mark - 调试函数耗时的利器CFAbsoluteTimeGetCurrent
-(void)RunCFAbsoluteTimeGetCurrent{
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    for(int i =0;i<100;i++){
        NSLog(@"%d",i);
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"time cost: %0.10f", end - start);
}

#pragma mark - 正则
-(void)testRegular{
    NSArray *array = @[@"k/v1/errors/questions/13784758695",
                       @"p/v1/practices/13784758695",
                       @"dfgdgagaddadfk/v1/collects/123123123123",
                       @"k/v1/errors/questions/[0-9]",
                       @"p/v1/practices/3425543/",
                       @"p/v1/practices/3123123123/answers"];
    for(NSString *url in array){
        NSLog(@"%@",[self cacheKeyWithUrl:url]);
    }
}

-(NSString *)cacheKeyWithUrl:(NSString *)url{
    NSString *cacheKey = @"";
    NSArray *regexArray = @[@"^.*k/v1/errors/questions/+[0-9]+$",
                            @"^.*p/v1/practices/+[0-9]+$",
                            @"^.*k/v1/collects/+[0-9]+$",
                            @"^.*p/v1/practices/+[0-9]+$",
                            @"^.*p/v1/practices/+[0-9]+/answers$"];
    for(NSString *regex in regexArray){
        BOOL result = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:url];
        if(result){
            return regex;
        }
    }
    return cacheKey;
}

-(NSString *)cacheKeygetZTKDeleteErrorQuestions:(NSString *)url{
    NSString *regexString = @"k/v1/errors/questions/+[0-9]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    if([test evaluateWithObject:url]){
        return regexString;
    }else{
        return nil;
    }
}

-(BOOL)isgetZTKWatchPracticeUrl:(NSString *)url{
    NSString *regexString = @"p/v1/practices/+[0-9]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    return [test evaluateWithObject:url];
}

//清楚题目中无用的标签
-(NSString *)clearUselessLabel:(NSString *)string{
    //    string = [string stringByReplacingOccurrencesOfString:@"<p style=\"display:inline\">" withString:@""];
    //    string = [string stringByReplacingOccurrencesOfString:@"<p class=\"item-p\">" withString:@""];
    string = @"<p style=\"display:inline\";>123123123";
    string = @"<pclass=\"item-p\">税率，是对征税对象的征收比例或征收额度。税率过高，会提高交易成本，从而抑制消费，所以C选项错误。如果目前税率处在拉弗曲线的40%以下的某处，则提高税率，可增加税收；相反，如果目前税率处在拉弗曲线的40%以上的某处，则降低税率，可增加税收。所以A选项和D选项错误。因此，本题选择B选项</p>";
//    string = [string stringByReplacingOccurrencesOfString:@"^<p.+>$" withString:@""];
    NSString *result = [string stringByReplacingOccurrencesOfString:@"<p+.+\">+"
                                             withString:@""
                                                options:NSRegularExpressionSearch // 注意里要选择这个枚举项,这个是用来匹配正则表达式的
                                                  range:NSMakeRange (0, string.length)];
    NSLog(@"%@",result);
    
    return result;
}

-(void)testAFBASE64{
    NSString *aesString = [SSTool AESEncryptWith256Key:@"{\"newpsw\":\"12345678\",\"username\":\"SHCT-BQ\",\"oldpsw\":\"123456\"}" encryptKey:@"0B762C6DB5FD3B0D31D86F56E0E82312" iv:nil];
    NSString *afbase64 = [SSTool AFBase64EncodedStringFromString:@"12345678asdfghjklop"];
    NSData *plainData = [@"12345678asdfghjklop" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    NSLog(@"aesString = %@",aesString);
    NSLog(@"afbase64 = %@",afbase64);
    NSLog(@"base64String = %@",base64String);
}

//-(NSString *)regexString:(NSString *)baseString{
//    //law/searchTitleDetail?LawID=403315&Query
//    NSString *regex = @"^.*law/searchTitleDetail?LawID=+[0-9]+&Query$";
//    NSPredicate *test = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:baseString];
//    if([test evaluateWithObject:baseString]){
//        return regex;
//    }else{
//        return nil;
//    }
//}


#pragma mark - 获取目录大小
-(void)testFileSize{
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    CGFloat size = [FunctionViewController folderSizeAtPath2:stringPath];
    NSLog(@"filesize = %f",size);
}

//循环调用fileSizeAtPath来获取一个目录所占空间大小
+ (long long) folderSizeAtPath2:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end
