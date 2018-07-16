//
//  LawChinaViewController.m
//  Example
//
//  Created by Sseakom on 2018/6/14.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import "LawChinaViewController.h"
#import "FMDatabase.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "SSRequest.h"
#import "Ono.h"

@interface LawChinaViewController ()

@property(nonatomic,strong) FMDatabase *db;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger lawID;

@end

@implementation LawChinaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configdefaultData];
    //[self loadDB];
    //[self loadDataSource];
    [self requestLawInfo];
}

-(void)configdefaultData{
    //self.lawID = 398931;
    self.lawID = 402772;
}

-(void)loadDB{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *dbPath = [mainBundle pathForResource:@"lawen" ofType:@"db"];
    self.db = [FMDatabase databaseWithPath:dbPath];
    BOOL res;
    res = [self.db setKey:@"LwFL0Yga$UasyPd$e9@wDWa"];
    if(!res){
        NSLog(@"设置失败");
    }
}

-(void)loadDataSource{
    BOOL res = [self.db open];
    if (res == NO) {
        NSLog(@"打开失败");
        return;
    }
    res = [self.db setKey:@"LwFL0Yga$UasyPd$e9@wDWa"];
    if(!res){
        NSLog(@"设置失败");
    }
    //如果没有表，创建表
    res = [self.db executeUpdate:@"create table if not exists SIGNCLASS(id integer primary key autoincrement,classnum text,classname text,classdate text,classstartdate text,classenddate text,studentname text,studentstudynum text,certificatenum text,userid text)"];
    if (res == NO) {
        NSLog(@"创建失败");
        [self.db close];
        return ;
    }
}

-(void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestLawInfo) userInfo:nil repeats:YES];
}

-(void)requestLawInfo{
    NSDictionary *dic = @{@"LawID":@(self.lawID),@"Query":@"中国"};
    SSRequest *request = [[SSRequest alloc]init];
    request.requestUrl = @"http://search.chinalaw.gov.cn/law/searchTitleDetail";
    request.requestArgument = dic;
    request.requestMethod = YTKRequestMethodGET;
    request.requestSerializerType = YTKRequestSerializerTypeJSON;
    request.responseSerializerType = YTKResponseSerializerTypeHTTP;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSString *responseString = request.responseString;
        NSDictionary *dic = request.requestArgument;
        NSString *lawID = dic[@"LawID"];
        NSString *Query = dic[@"Query"];
        if([responseString isEqualToString:@"法规不存在!"]){
            NSLog(@"法规不存在! lawid - %ld",(long)lawID);
        }else{
            NSLog(@"lawid - %ld",(long)lawID);
            NSRange startRange = [responseString rangeOfString:@"<!--** 主体开始 **-->"];
            NSRange endRange = [responseString rangeOfString:@"<!--** 主体结束 **-->"];
            NSInteger startIndex = startRange.location + startRange.length;
            NSInteger endIndex = endRange.location;
            NSRange range = NSMakeRange(startIndex, endIndex - startIndex);
            NSString *str = [responseString substringWithRange:range];
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
            
            NSLog(@"%@",str);
            [self parseHTML:str];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        NSLog(@"request law faulure");
    }];
    self.lawID++;
}

-(void)parseHTML:(NSString *)html{
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

    __block ONOXMLElement *detailConElement = nil;
    __block ONOXMLElement *titleElement = nil;
    __block ONOXMLElement *attributesElement = nil;
    __block ONOXMLElement *contentElement = nil;
    
    NSArray *directoryArray ;
    
    NSMutableArray *contentArray = [[NSMutableArray alloc]init];

    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithString:html encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"[Error] %@", error);
        return;
    }
    NSLog(@"Root Element: %@", document.rootElement.tag);
    
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
        NSLog(@"title - %@",title);
    }];
    
    //获取attributes元素
    NSString *attributesPath = @"//table[@class='d_infor']";
    [document enumerateElementsWithXPath:attributesPath usingBlock:^(ONOXMLElement * _Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
        attributesElement = element;
        //NSLog(@"title - %@",title);
        NSString *path = @"//table[@class='d_infor']/tr/td";
        [attributesElement enumerateElementsWithXPath:path usingBlock:^(ONOXMLElement * _Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@",element);
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
            NSLog(@"公布机关 - %@\n公布日期 - %@\n施行日期 - %@\n效力 - %@\n门类 - %@",publicOffice,publicDate,runDate,effective,category);
        }];
    }];
    
    //获取内容元素
    NSString *contentPath = @"//div[@class='con']";
    [document enumerateElementsWithXPath:contentPath usingBlock:^(ONOXMLElement * _Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
        contentElement = element;
        NSLog(@"contentElement - %@",contentElement);
    }];

    for(ONOXMLElement *obj in contentElement.children){
        NSLog(@"obj - %@",obj);
        
        NSInteger index = [contentElement.children indexOfObject:obj];
        if(index == 0){
            explanation = obj.stringValue;
            NSLog(@"题注 - %@",explanation);
        }else{
            if(obj.stringValue.length > 0 ){
                NSString *oID = [obj valueForAttribute:@"id"];
                if(oID.length > 0){
                    //组 - 目录或者章节
                    //解析组
                    NSLog(@"节点 - %@",obj.stringValue);
                    NSString *title = obj.stringValue;
                    NSArray *array = [self parseGroupElement:obj];
                    if([title isEqualToString:@"目录"]){
                        directoryArray = array;
                    }else{
                        NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
                        [mDic setObject:title forKey:@"chapter"];
                        [mDic setObject:array forKey:@"chapter_list"];
                        [contentArray addObject:mDic];
                    }
                }
            }
        }
    }

    NSLog(@"title - %@",title);
    NSLog(@"publicOffice - %@",publicOffice);
    NSLog(@"publicDate - %@",publicDate);
    NSLog(@"runDate - %@",runDate);
    NSLog(@"effective - %@",effective);
    NSLog(@"category - %@",category);
    NSLog(@"explanation - %@",explanation);
    
    NSLog(@"directory - %@",directoryArray);
    NSLog(@"content - %@",contentArray);
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
    NSDictionary *dic = [self parseTabelNodeElement:obj];
    ONOXMLElement *next = obj;
    while (dic) {
        [mArray addObject:dic];
        next = [self nextElement:next];
        dic = [self parseTabelNodeElement:next];
    }
    return mArray;
}

-(NSDictionary *)parseTabelNodeElement:(ONOXMLElement *)element{
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
            
            NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
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
                    [mDic setObject:mArray forKey:@"td_list"];
                }else{
                    //td标签里的内容
                    [mDic setObject:element.stringValue forKey:@"td_title"];
                }
            }];
            return mDic;
        }else{
            return [self parseTabelNodeElement:element.nextSibling];
        }
    }
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

@end
