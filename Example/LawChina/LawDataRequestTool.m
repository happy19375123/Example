//
//  LawRequestTool.m
//  Example
//
//  Created by Sseakom on 2018/7/25.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import "LawDataRequestTool.h"
#import "FMDatabase.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "SSRequest.h"
#import "Ono.h"
#import <MJExtension/MJExtension.h>

@interface LawDataRequestTool()

@property(nonatomic,strong) FMDatabase *db;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger lawID;
@property(nonatomic,strong) NSMutableDictionary *mDic;

@end

@implementation LawDataRequestTool

-(instancetype)init{
    self = [super init];
    if(self){
        [self configdefaultData];
    }
    return self;
}

-(void)configdefaultData{
    //398931 -
    //402667 - 正常
    //402777 - 决定或单条解释
    //400279 - 司法解释
    //self.lawID = 398931;
    //self.lawID = 396545;
    
    self.mDic = [[NSMutableDictionary alloc]init];
}

-(void)requestLawDataWithLawID:(NSInteger )lawID resultBlock:(CompletionBlock )completionBlock{
    if(![self filterLawID:lawID]){
        NSLog(@"error");
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc]init];
        [resultDic setObject:@"100011" forKey:@"error"];
        [resultDic setObject:@"lawid已过滤" forKey:@"msg"];
        if(completionBlock){
            completionBlock(resultDic,nil);
        }
        return;
    }
    self.lawID = lawID;
    [self requestLawInfoWithPageIndex:1 resultBlock:completionBlock];
}

-(void)requestLawInfoWithPageIndex:(NSInteger )pageIndex resultBlock:(CompletionBlock )completionBlock{
    NSDictionary *dic = @{@"LawID":@(self.lawID),@"Query":@"中国",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex]};
    SSRequest *request = [[SSRequest alloc]init];
    request.requestUrl = @"http://search.chinalaw.gov.cn/law/searchTitleDetail";
    request.requestArgument = dic;
    request.requestMethod = YTKRequestMethodGET;
    request.requestSerializerType = YTKRequestSerializerTypeJSON;
    request.responseSerializerType = YTKResponseSerializerTypeHTTP;
    
    //使用bjl时注意，在递归时有问题
    //bjl_weakify(self)
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //bjl_strongify(self)
        //NSLog(@"request - %@",request.currentRequest);
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc]init];
        NSString *responseString = request.responseString;
        NSDictionary *dic = request.requestArgument;
        NSString *lawID = dic[@"LawID"];
        NSString *Query = dic[@"Query"];
        if([responseString isEqualToString:@"法规不存在!"]){
            NSLog(@"法规不存在! lawid - %ld",(long)lawID);
            [resultDic setObject:@"100001" forKey:@"error"];
            [resultDic setObject:[NSString stringWithFormat:@"法规不存在! lawid - %ld",(long)lawID] forKey:@"msg"];
            if(completionBlock){
                completionBlock(resultDic,nil);
            }
        }else{
            //NSLog(@"lawid - %ld",(long)lawID);
            NSRange startRange = [responseString rangeOfString:@"<!--** 主体开始 **-->"];
            NSRange endRange = [responseString rangeOfString:@"<!--** 主体结束 **-->"];
            NSInteger startIndex = startRange.location + startRange.length;
            NSInteger endIndex = endRange.location;
            NSRange range = NSMakeRange(startIndex, endIndex - startIndex);
            NSString *str = [responseString substringWithRange:range];
            str = [self clearHTMLLabel:str];
            NSString *lawID = dic[@"LawID"];
            NSInteger pageIndex = [dic[@"PageIndex"] integerValue];
            LawModel *model = [self parseHTML:str];
            model.lawID = lawID;
            [self saveLawModel:model];
            if(pageIndex == model.pageCount){
                //TODO - 请求完成，进行持久化
                LawModel *baseModel = [self.mDic objectForKey:model.lawID];
                baseModel = [self checkMultiLevel:baseModel];
                NSString *lawPath = [self writeToFileWithModel:baseModel];
                
                [resultDic setObject:@"100000" forKey:@"error"];
                [resultDic setObject:@"Success" forKey:@"msg"];
                [resultDic setObject:lawPath forKey:@"path"];
                [resultDic setObject:model forKey:@"model"];
                if(completionBlock){
                    completionBlock(resultDic,nil);
                }
            }else if(pageIndex < model.pageCount){
                [self requestLawInfoWithPageIndex:pageIndex+1 resultBlock:completionBlock];
            }else{
                NSLog(@"error");
                [resultDic setObject:@"100010" forKey:@"error"];
                [resultDic setObject:@"failure" forKey:@"msg"];
                [resultDic setObject:model forKey:@"model"];
                if(completionBlock){
                    completionBlock(resultDic,nil);
                }
            }
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
}

-(LawModel *)checkMultiLevel:(LawModel *)baseModel{
    if(baseModel.buildType == 1){
        baseModel = [self configChapterLevel:baseModel];
        
        //章合并节
        baseModel = [self mergrChapterWithLawModel:baseModel level:3];
        //清楚节节点
        baseModel = [self clearChapterWithLawModel:baseModel level:4];
        
        if(baseModel.maxLevel == 2){
            //编合并章
            baseModel = [self mergrChapterWithLawModel:baseModel level:2];
            //清楚章节点
            baseModel = [self clearChapterWithLawModel:baseModel level:3];
        }
    }
    return baseModel;
}

-(LawModel *)mergrChapterWithLawModel:(LawModel *)baseModel level:(NSInteger )mergeLevel{
    for(int i=0;i<baseModel.contentArray.count;i++){
        if(i+1 >= baseModel.contentArray.count){
            break;
        }
        LawChapterModel *chapterModel = baseModel.contentArray[i];
        NSInteger level = chapterModel.level;
        LawChapterModel *nextChapterModel = baseModel.contentArray[++i];
        NSInteger nextLevel = nextChapterModel.level;
        if(level == mergeLevel){
            while (nextLevel > mergeLevel) {
                [chapterModel.chapterModelArray addObject:nextChapterModel];
                ++i;
                if(i >= baseModel.contentArray.count){
                    break;
                }
                nextChapterModel = baseModel.contentArray[i];
                nextLevel = nextChapterModel.level;
            }
            i--;
        }else{
            i--;
        }
    }
    
    return baseModel;
}

-(LawModel *)clearChapterWithLawModel:(LawModel *)baseModel level:(NSInteger )clearLevel{
    for(int i=0;i<baseModel.contentArray.count;i++){
        LawChapterModel *chapterModel = baseModel.contentArray[i];
        if(chapterModel.level == clearLevel){
            [baseModel.contentArray removeObject:chapterModel];
            i--;
        }
    }
    return baseModel;
}

//如果buildType为1时，为各章节设置层级,2-编，3-章，4-节，方便合并
-(LawModel *)configChapterLevel:(LawModel *)baseModel{
    if(baseModel.buildType == 1){
        for(LawChapterModel *obj in baseModel.contentArray){
            NSString *title = obj.chapterTitle;
            NSInteger level = [self levelForLawChapterModelWithTitle:title];
            obj.level = level;
            if(level < baseModel.maxLevel){
                baseModel.maxLevel = level;
            }
        }
    }
    return baseModel;
}

//当buildType为2时，合并item
-(LawModel *)mergrItemWithLawModel:(LawModel *)model{
    if(model.buildType == 2){
        //合并item到chapter
        LawChapterModel *lastChapterModel = nil;
        for(NSObject *obj in model.contentArray){
            if([obj isKindOfClass:[LawChapterModel class]]){
                lastChapterModel = (LawChapterModel *)obj;
            }
            if([obj isKindOfClass:[LawItemModel class]]){
                LawItemModel *itemModel = (LawItemModel *)obj;
                if(lastChapterModel && itemModel.itemArray.count > 0){
                    [lastChapterModel.itemModelArray addObject:obj];
                }
            }
        }
        
        //清楚contentArray里的item
        NSMutableArray *newContentArray = [[NSMutableArray alloc]init];
        for(NSObject *obj in model.contentArray){
            if([obj isKindOfClass:[LawChapterModel class]]){
                [newContentArray addObject:obj];
            }
        }
        model.contentArray = newContentArray;
    }

    return model;
}

-(NSString *)writeToFileWithModel:(LawModel *)model{
    NSString *json = [model mj_JSONString];
    //NSString *lawPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/law/%@.txt",model.lawID]];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *lawPath = [NSString stringWithFormat:@"%@/%@.txt",documentsPath,model.lawID];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    [json writeToFile:lawPath atomically:NO encoding:NSUTF8StringEncoding error:&error];
    /*
    if (![fm fileExistsAtPath:lawPath]) {
        //[fm createDirectoryAtPath:lawPath withIntermediateDirectories:YES attributes:nil error:nil];
        [json writeToFile:lawPath atomically:NO encoding:NSUTF8StringEncoding error:&error];
    } else {
        NSLog(@"imagesPaths is Exists.");
        [json writeToFile:lawPath atomically:NO encoding:NSUTF8StringEncoding error:&error];
    }
     */
    NSLog(@"\nlawID - %@\nlawTitle - %@\nlawPath - %@",model.lawID,model.title,lawPath);
    return lawPath;
}

-(void)saveLawModel:(LawModel *)model{
    if([self.mDic.allKeys containsObject:model.lawID]){
        LawModel *baseModel = [self.mDic objectForKey:model.lawID];
        if(baseModel.buildType == 1){
            //正常法条
            for(LawChapterModel *addChapterModel in model.contentArray){
                BOOL isInBase = NO;
                for(LawChapterModel *baseChapterModel in baseModel.contentArray){
                    if([baseChapterModel.chapterTitle isEqualToString:addChapterModel.chapterTitle]){
                        isInBase = YES;
                        [baseChapterModel.itemModelArray addObjectsFromArray:addChapterModel.itemModelArray];
                    }
                }
                if(!isInBase){
                    //是新的章节添加到base章节后
                    [baseModel.contentArray addObject:addChapterModel];
                }
            }
            
        }else if(baseModel.buildType == 2){
            //决定
            /* 原版本
            for(LawChapterModel *addChapterModel in model.contentArray){
                BOOL isInBase = NO;
                for(LawChapterModel *baseChapterModel in baseModel.contentArray){
                    if([baseChapterModel.chapterTitle isEqualToString:addChapterModel.chapterTitle]){
                        isInBase = YES;
                        [baseChapterModel.itemModelArray addObjectsFromArray:addChapterModel.itemModelArray];
                    }
                }
                if(!isInBase){
                    //是新的章节添加到base章节后
                    [baseModel.contentArray addObject:addChapterModel];
                }
            }
             */
            
            model = [self mergrItemWithLawModel:model];
            
            for(LawChapterModel *addChapterModel in model.contentArray){
                BOOL isInBase = NO;
                for(LawChapterModel *baseChapterModel in baseModel.contentArray){
                    if([baseChapterModel.chapterTitle isEqualToString:addChapterModel.chapterTitle]){
                        isInBase = YES;
                        [baseChapterModel.itemModelArray addObjectsFromArray:addChapterModel.itemModelArray];
                    }
                }
                if(!isInBase){
                    //是新的章节添加到base章节后
                    [baseModel.contentArray addObject:addChapterModel];
                }
            }
        }else{
            
        }
        
    }else{
        //NSMutableArray *mArray = [[NSMutableArray alloc]init];
        
        model = [self mergrItemWithLawModel:model];

        [self.mDic setObject:model forKey:model.lawID];
    }
}

-(LawModel *)parseHTML:(NSString *)html{
    LawModel *lawModel = [[LawModel alloc]init];
    
    NSError *error = nil;
    __block NSString *title = @"";
    //公布机关
    __block NSString *publicOffice = @"";
    //公布日期
    __block NSString *publicDate = @"";
    //施行日期
    __block NSString *runDate = @"";
    //效力
    __block NSString *effective = @"";
    //门类
    __block NSString *category = @"";
    
    //题注说明
    __block NSString *explanation = @"";
    
    //页数
    __block NSInteger pageCount = 1;
    
    __block ONOXMLElement *detailConElement = nil;
    __block ONOXMLElement *titleElement = nil;
    __block ONOXMLElement *attributesElement = nil;
    __block ONOXMLElement *contentElement = nil;
    
    NSArray *directoryArray ;
    
    NSMutableArray *contentArray = [[NSMutableArray alloc]init];
    
    //baseModel用于做判断取值，lawModel用于存数据
    LawModel *baseModel = [self.mDic objectForKey:@(self.lawID)];
    if(baseModel && baseModel.buildType == 2){
        //法律为决定，contentArray 添加最后一个章节model的标题
        //lawModel = baseModel;
        LawChapterModel *baseLastChapterModel = baseModel.contentArray.lastObject;
        LawChapterModel *lastChapterModel = [[LawChapterModel alloc]init];
        lastChapterModel.chapterTitle = baseLastChapterModel.chapterTitle;
        [contentArray addObject:lastChapterModel];
    }
    
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithString:html encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"[Error] %@", error);
        return nil;
    }
    //NSLog(@"Root Element: %@", document.rootElement.tag);
    
    //获取detailCon元素
    NSString *detailConPath = @"//div[@class='detailCon']";
    [document enumerateElementsWithXPath:detailConPath usingBlock:^(ONOXMLElement *element, __unused NSUInteger idx, __unused BOOL *stop) {
        detailConElement = element;
    }];
    
    //获取title元素
    NSString *titlePath = @"//div[@class='conTit']";
    [document enumerateElementsWithXPath:titlePath usingBlock:^(ONOXMLElement * _Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
        titleElement = element;
        title = element.stringValue;
        //NSLog(@"title - %@",title);
    }];
    
    //获取attributes元素
    NSString *attributesPath = @"//table[@class='d_infor']";
    [document enumerateElementsWithXPath:attributesPath usingBlock:^(ONOXMLElement * _Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
        attributesElement = element;
        //NSLog(@"title - %@",title);
        NSString *path = @"//table[@class='d_infor']/tr/td";
        [attributesElement enumerateElementsWithXPath:path usingBlock:^(ONOXMLElement * _Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
            //NSLog(@"%@",element);
            switch (idx) {
                case 1:
                    publicOffice = element.stringValue;
                    break;
                case 3:
                    publicDate = element.stringValue;
                    break;
                case 5:
                    runDate = element.stringValue;
                    break;
                case 7:
                    effective = element.stringValue;
                    break;
                case 9:
                    category = element.stringValue;
                    break;
                default:
                    break;
            }
            //NSLog(@"公布机关 - %@\n公布日期 - %@\n施行日期 - %@\n效力 - %@\n门类 - %@",publicOffice,publicDate,runDate,effective,category);
        }];
    }];
    
    //获取内容元素
    NSString *contentPath = @"//div[@class='con']";
    [document enumerateElementsWithXPath:contentPath usingBlock:^(ONOXMLElement * _Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
        contentElement = element;
        //NSLog(@"contentElement - %@",contentElement);
    }];
    
    for(ONOXMLElement *obj in contentElement.children){
        //NSLog(@"obj - %@",obj);
        NSInteger index = [contentElement.children indexOfObject:obj];
        if(index == 0){
            explanation = obj.stringValue;
            //NSLog(@"题注 - %@",explanation);
        }else{
            if(obj.stringValue.length > 0 ){
                NSString *oID = [obj valueForAttribute:@"id"];
                NSString *class = [obj valueForAttribute:@"class"];
                if(oID.length > 0){
                    //组 - 目录或者章节
                    //解析组
                    //NSLog(@"节点 - %@",obj.stringValue);
                    NSString *title = obj.stringValue;
                    NSArray *array = [self parseGroupElement:obj];
                    if([title isEqualToString:@"目录"]){
                        directoryArray = array;
                    }else{
                        LawChapterModel *model = [[LawChapterModel alloc]init];
                        model.chapterTitle = title;
                        [model.itemModelArray addObjectsFromArray:array];
                        [contentArray addObject:model];
                        lawModel.buildType = 1;
                    }
                }else if([class isEqualToString:@"law22"]){
                    //判断法律为决定
                    NSString *title = obj.stringValue;
                    LawChapterModel *model = [[LawChapterModel alloc]init];
                    model.chapterTitle = title;
                    [contentArray addObject:model];
                    lawModel.buildType = 2;
                }else{
                    //其他情况
                    if(baseModel.buildType == 1 || lawModel.buildType == 1){
                        //正常法律
                    }else if (baseModel.buildType == 2 || lawModel.buildType == 2){
                        //决定
                        
                        NSObject *lastObject = contentArray.lastObject;
                        if([lastObject isKindOfClass:[LawChapterModel class]]){
                            //章
                            //LawChapterModel *chapterModel = contentArray.lastObject;
                            if(![obj.stringValue isEqualToString:@""]){
                                LawItemModel *itemModel = [[LawItemModel alloc]init];
                                [itemModel.itemArray addObject:obj.stringValue];
                            }
                        }else if([lastObject isKindOfClass:[LawItemModel class]]){
                            //节
                            LawItemModel *itemModel = contentArray.lastObject;
                            if(![obj.stringValue isEqualToString:@""]){
                                [itemModel.itemArray addObject:obj.stringValue];
                            }
                        }
                    }else{
                        
                    }
                }
            }else if ([obj.tag isEqualToString:@"item"]){
                LawItemModel *itemModel = [[LawItemModel alloc]init];
                [contentArray addObject:itemModel];
                lawModel.buildType = 2;
            }
        }
    }
    
    //获取pagecount
    NSString *pageCountPath = @"//span[@id='pagecount']";
    [document enumerateElementsWithXPath:pageCountPath usingBlock:^(ONOXMLElement * _Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
        pageCount = [element.stringValue integerValue];
        //NSLog(@"pageCount - %ld",(long)pageCount);
    }];
    
//    NSLog(@"title - %@",title);
//    NSLog(@"publicOffice - %@",publicOffice);
//    NSLog(@"publicDate - %@",publicDate);
//    NSLog(@"runDate - %@",runDate);
//    NSLog(@"effective - %@",effective);
//    NSLog(@"category - %@",category);
//    NSLog(@"explanation - %@",explanation);
//    NSLog(@"pageCount - %ld",(long)pageCount);
//
//    NSLog(@"directory - %@",directoryArray);
//    NSLog(@"content - %@",contentArray);
    
    lawModel.title = title;
    lawModel.publicOffice = publicOffice;
    lawModel.publicDate = publicDate;
    lawModel.runDate = runDate;
    lawModel.effective = effective;
    lawModel.category = category;
    [lawModel.directoryArray addObjectsFromArray:directoryArray];
    [lawModel.contentArray addObjectsFromArray:contentArray];
    lawModel.pageCount = pageCount;
    return lawModel;
}

-(ONOXMLElement *)nextElement:(ONOXMLElement *)element{
    if(element){
        NSArray *array = element.parent.children;
        NSInteger index = [array indexOfObject:element];
        NSInteger next = index + 1;
        if(array.count > next){
            return array[next];
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

-(NSArray *)parseGroupElement:(ONOXMLElement *)element{
    //解析组节点下的节点，遇到另一个组结束
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    ONOXMLElement *obj = [self nextElement:element];
    LawItemModel *model = [self parseTabelNodeElement:obj];
    ONOXMLElement *next = obj;
    while (model) {
        [mArray addObject:model];
        next = [self nextElement:next];
        model = [self parseTabelNodeElement:next];
    }
    return mArray;
}

-(LawItemModel *)parseTabelNodeElement:(ONOXMLElement *)element{
    if(!element){
        return nil;
    }
    
    NSString *oID = [element valueForAttribute:@"id"];
    if(oID.length > 0){
        //组 - 目录或者章节
        //解析组
        //[self parseGroupElement:element];
        return nil;
    }else{
        if([element.tag isEqualToString:@"table"]){
            NSError *error = nil;
            ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithString:element.description encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"[Error] %@", error);
            }
            
            LawItemModel *model = [[LawItemModel alloc]init];
            //获取td元素
            NSString *detailConPath = @"//td";
            [document enumerateElementsWithXPath:detailConPath usingBlock:^(ONOXMLElement *element, __unused NSUInteger idx, __unused BOOL *stop) {
                //获取td标签下的内容
                if(element.children.count > 0){
                    NSMutableArray *mArray = [[NSMutableArray alloc]init];
                    for(ONOXMLElement *obj in element.children){
                        if([obj.tag isEqualToString:@"p"]){
                            if(obj.stringValue.length > 0){
                                [mArray addObject:obj.stringValue];
                            }
                        }else{
                            NSLog(@"[Error] - td 标签下不是p标签");
                        }
                    }
                    [model.itemArray addObjectsFromArray:mArray];
                }else{
                    //td标签里的内容
                    model.itemTitle = element.stringValue;
                }
            }];
            return model;
        }else{
            return [self parseTabelNodeElement:element.nextSibling];
        }
    }
}

-(NSString *)clearHTMLLabel:(NSString *)str{
    //特殊替换，buildtype为2时，充当分隔itemmodel的标记
    str = [str stringByReplacingOccurrencesOfString:@"</br> <hr>" withString:@"<item></item>"];
    
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"\\<"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@"\\>"];
    //str = [str stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    //str = [str stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    
    //特殊替换，否则解析失败，原因不明
    str = [str stringByReplacingOccurrencesOfString:@"border=0" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"valign=top" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"nowrap=nowrap" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"nowrap" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<hr>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&#32;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    //去掉无用的标签 <font color='red'>
    str = [str stringByReplacingOccurrencesOfString:@"<font color='red'>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
    
    //去掉script标签
    str = [self test:str];
    
    str = [self matchingChineseCharacters:str];
    
    return str;
}

-(NSString *)test:(NSString *)baseString{
    NSString *regex = @"<script[\\d\\D]*/script>";
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
        baseString = [baseString stringByReplacingOccurrencesOfString:mStr withString:@""];
    }
    return baseString;
}

//将尖括号<>替换成〈〉
-(NSString *)matchingChineseCharacters:(NSString *)baseString{
    //baseString = @"<我的>";
    //[\u4e00-\u9fa5]
    NSString *regex = @"<[\u4e00-\u9fa5]+>";
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
        NSString *replaceString = [mStr copy];
        replaceString = [replaceString stringByReplacingOccurrencesOfString:@"<" withString:@"〈"];
        replaceString = [replaceString stringByReplacingOccurrencesOfString:@">" withString:@"〉"];
        baseString = [baseString stringByReplacingOccurrencesOfString:mStr withString:replaceString];
    }
    return baseString;

}

/**
 *  后期需要确认，是否通用
 *  编 - 一、二、。。。编/部分
 *      返回值 - 2
 *  章 - 一、二、。。。章/、
 *      返回值 - 3
 *  节 - 一、二、。。。节
 *      返回值 - 4
 *
 */
-(NSInteger )levelForLawChapterModelWithTitle:(NSString *)baseString{
    NSInteger level = -1;
    //[一二三四五六七八九十]{1,}
    NSString *regex = @"[一二三四五六七八九十百]{1,}[编部分、章节]{1,}";
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    // 对str字符串进行匹配
    NSArray *matches = [regular matchesInString:baseString
                                        options:0
                                          range:NSMakeRange(0, baseString.length)];

    if(matches.count > 0){
        NSTextCheckingResult *match = matches[0];
        NSRange range = [match range];
        NSString *mStr = [baseString substringWithRange:range];
        if([mStr hasSuffix:@"编"]){
            level = 2;
        }else if ([mStr hasSuffix:@"部分"]){
            level = 2;
        }else if ([mStr hasSuffix:@"章"]){
            level = 3;
        }else if ([mStr hasSuffix:@"、"]){
            level = 3;
        }else if ([mStr hasSuffix:@"节"]){
            level = 4;
        }
        
    }
    return level;
}


//XPATH 例子
-(void)example{
    /**
     路径表达式    结果
     /bookstore/book[1]             选取属于 bookstore 子元素的第一个 book 元素。
     /bookstore/book[last()]        选取属于 bookstore 子元素的最后一个 book 元素。
     /bookstore/book[last()-1]      选取属于 bookstore 子元素的倒数第二个 book 元素。
     /bookstore/book[position()<3]  选取最前面的两个属于 bookstore 元素的子元素的 book 元素。
     //title[@lang]                 选取所有拥有名为 lang 的属性的 title 元素。
     //title[@lang='eng']           选取所有 title 元素，且这些元素拥有值为 eng 的 lang 属性。
     /bookstore/book[price>35.00]   选取 bookstore 元素的所有 book 元素，且其中的 price 元素的值须大于 35.00。
     /bookstore/book[price>35.00]/title
     选取 bookstore 元素中的 book 元素的所有 title 元素，且其中的 price 元素的值须大于 35.00。
     */
}

//需要过滤的ID - 333138，
-(BOOL)filterLawID:(NSInteger )lawid{
    NSArray *array = @[@333138];
    if([array containsObject:[NSNumber numberWithInteger:lawid]]){
        return NO;
    }else{
        return YES;
    }
}


@end
