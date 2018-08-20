//
//  LawEffectLevelRequestTool.m
//  Example
//
//  Created by Sseakom on 2018/7/25.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import "LawEffectLevelRequestTool.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "SSRequest.h"
#import "Ono.h"
#import <MJExtension/MJExtension.h>

@interface LawEffectLevelRequestTool()

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger lawID;
@property(nonatomic,strong) NSMutableDictionary *mDic;
@property(nonatomic,copy) NSString *keyword;

@end

@implementation LawEffectLevelRequestTool

-(instancetype)init{
    self = [super init];
    if(self){
        [self configdefaultData];
    }
    return self;
}

-(void)configdefaultData{
    //国、法、的、定、中、0、1、2、关、例、
    self.keyword = @"例";
    self.mDic = [[NSMutableDictionary alloc]init];
}

-(void)requestLawInfoWithPageIndex:(NSInteger )pageIndex resultBlock:(CompletionBlock )completionBlock{
    NSDictionary *dic = @{@"Query":self.keyword,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex],@"SiteID":@"124",@"effectLevel":@"2",@"Sort":@"PublishTime",@"Type":@"1"};
    SSRequest *request = [[SSRequest alloc]init];
    request.requestUrl = @"http://search.chinalaw.gov.cn/SearchLawTitle";
    request.requestArgument = dic;
    request.requestMethod = YTKRequestMethodGET;
    request.requestSerializerType = YTKRequestSerializerTypeJSON;
    request.responseSerializerType = YTKResponseSerializerTypeHTTP;
    
    //使用bjl时注意，在递归时有问题
    //bjl_weakify(self)
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //bjl_strongify(self)
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc]init];
        NSString *responseString = request.responseString;
        NSDictionary *dic = request.requestArgument;
        
        NSRange startRange = [responseString rangeOfString:@"<!--** 主体开始 **-->"];
        NSRange endRange = [responseString rangeOfString:@"<!--** 主体结束 **-->"];
        NSInteger startIndex = startRange.location + startRange.length;
        NSInteger endIndex = endRange.location;
        NSRange range = NSMakeRange(startIndex, endIndex - startIndex);
        
        NSString *str = [responseString substringWithRange:range];
        str = [self clearHTMLLabel:str];
        NSString *effectLevel = dic[@"effectLevel"];
        NSInteger pageIndex = [dic[@"PageIndex"] integerValue];
        NSInteger pageCount = [self parseHTML:str];
        NSArray *array = [self test:str];
        NSLog(@"%@",array);
        //存储lawID
        [self saveLawIDArray:array andEffectLevel:effectLevel];
        if(pageIndex == pageCount){
            //TODO - 请求完成,持久化
            NSArray *lawIDArray = [self.mDic objectForKey:effectLevel];
            NSString *effectLevelPath = [self writeToFileWithArray:lawIDArray effectLevel:effectLevel];
            
            [resultDic setObject:@"100000" forKey:@"error"];
            [resultDic setObject:@"Success" forKey:@"msg"];
            [resultDic setObject:effectLevelPath forKey:@"path"];
            [resultDic setObject:lawIDArray forKey:@"data"];
            if(completionBlock){
                completionBlock(resultDic,nil);
            }
        }else{
            [self requestLawInfoWithPageIndex:pageIndex+1 resultBlock:completionBlock];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        NSLog(@"request law faulure");
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc]init];
        [resultDic setObject:@"100002" forKey:@"error"];
        [resultDic setObject:@"request law faulure" forKey:@"msg"];
        if(completionBlock){
            completionBlock(resultDic,request.error);
        }
    }];
    //self.lawID++;
}

-(NSString *)writeToFileWithArray:(NSArray *)array effectLevel:(NSString *)level{
    NSString *levelPath = [self loadEffectLevelPathEffectLevel:level];
    [array writeToFile:levelPath atomically:YES];
    NSLog(@"\neffectlevel - %@\nlevelPath - %@",level,levelPath);
    return levelPath;
}

-(void)saveLawIDArray:(NSArray *)array andEffectLevel:(NSString *)level{
    if([self.mDic.allKeys containsObject:level]){
        NSMutableArray *mArray = [[NSMutableArray alloc]initWithArray:[self.mDic objectForKey:level]];
        for(NSString *obj in array){
            if(![mArray containsObject:obj]){
                [mArray addObject:obj];
            }
        }
        [self.mDic setObject:mArray forKey:level];
    }else{
        NSString *levelPath = [self loadEffectLevelPathEffectLevel:level];
        NSArray *baseArray = [NSArray arrayWithContentsOfFile:levelPath];
        NSMutableArray *mArray = [[NSMutableArray alloc]initWithArray:baseArray];
        for(NSString *obj in array){
            if(![mArray containsObject:obj]){
                [mArray addObject:obj];
            }
        }
        [self.mDic setObject:mArray forKey:level];
    }
}

-(NSString *)clearHTMLLabel:(NSString *)str{
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    //特殊替换，否则解析失败，原因不明
    str = [str stringByReplacingOccurrencesOfString:@"border=0" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"valign=top" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"nowrap=nowrap" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"nowrap" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<hr>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    
    //去掉无用的标签 <font color='red'>
    str = [str stringByReplacingOccurrencesOfString:@"<font color='red'>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
    return str;
}

-(NSInteger )parseHTML:(NSString *)html{
    __block NSInteger pageCount = 1;
    
    NSError *error = nil;
    
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithString:html encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"[Error] %@", error);
        return 0;
    }
    
    //获取pagecount
    NSString *pageCountPath = @"//span[@id='pagecount']";
    [document enumerateElementsWithXPath:pageCountPath usingBlock:^(ONOXMLElement * _Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
        pageCount = [element.stringValue integerValue];
        NSLog(@"pageCount - %ld",(long)pageCount);
    }];

    return pageCount;
}

-(NSArray *)test:(NSString *)baseString{
    //baseString = @"searchTitleDetail?LawID=402778&Query=%E5%9B%BD&IsExact=";
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    NSString *regex = @"searchTitleDetail\\?LawID=+[0-9]+&Query";
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    // 对str字符串进行匹配
    NSArray *matches = [regular matchesInString:baseString
                                        options:0
                                          range:NSMakeRange(0, baseString.length)];
    // 遍历匹配后的每一条记录
    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match range];
        NSString *mStr = [baseString substringWithRange:range];
        mStr = [mStr stringByReplacingOccurrencesOfString:@"searchTitleDetail?LawID=" withString:@""];
        mStr = [mStr stringByReplacingOccurrencesOfString:@"&Query" withString:@""];
        [mArray addObject:mStr];
    }
    return mArray;
}

-(NSString *)loadEffectLevelPathEffectLevel:(NSString *)level{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *effectlevelPath = [NSString stringWithFormat:@"%@/effectlevel/",documentsPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![fm fileExistsAtPath:effectlevelPath]) {
        [fm createDirectoryAtPath:effectlevelPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"imagesPaths is Exists.");
    }
    NSString *levelPath = [NSString stringWithFormat:@"%@%@.txt",effectlevelPath,level];
    return levelPath;
}

@end
