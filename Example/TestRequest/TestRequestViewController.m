//
//  TestRequestViewController.m
//  Example
//
//  Created by Sseakom on 2017/11/10.
//  Copyright © 2017年 张鹏. All rights reserved.
//

#import "TestRequestViewController.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "SSRequest.h"

@interface TestRequestViewController ()

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger lawID;

@end

@implementation TestRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configdefaultData];
    //[self request];
    //[self ssrequestTest];
    //[self requestLawInfo];
    //[self startTimer];
    [self yingke_requestTest];
}

-(void)configdefaultData{
    self.lawID = 398931;
}

-(void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestLawInfo) userInfo:nil repeats:YES];
}

//获取cookie
-(void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    manager.requestSerializer.timeoutInterval = 0.20f;
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dic = @{@"appid":@"BDAF6B4D-5DC0-4AEF-BCF8-6C7EFC94DE99"};
    [manager GET:@"http://120.92.93.120/mapi_v2/User/quitregist" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        NSLog(@"cookies = %@",cookies);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"faulure");
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for(NSHTTPCookie *obj in cookies){
            NSLog(@"cookies = %@",obj.value);
        }
    }];
}

-(void)ssrequestTest{
    NSDictionary *dic = @{@"appid":@"BDAF6B4D-5DC0-4AEF-BCF8-6C7EFC94DE99"};
    SSRequest *request = [[SSRequest alloc]init];
    request.requestUrl = @"http://120.92.93.120/mapi_v2/User/quitregist";
    request.requestArgument = dic;
    request.requestMethod = YTKRequestMethodGET;
    request.requestSerializerType = YTKRequestSerializerTypeJSON;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
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
            NSLog(@"%@",str);
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        NSLog(@"request law faulure");
    }];
    self.lawID++;
}

//https://service.inke.cn/api/user_feed/recommend?gender=1&user_level=9&longitude=200&location=%2C%2C&offset=0&session_id=1534315285&latitude=200&lc=0000000000000107&cc=TG0001&cv=IK6.1.45_Iphone&proto=13&idfa=1C6E6DAE-E9CD-409E-9DE3-CE049F43D77C&idfv=310BD347-E30F-4848-87D5-FC35332AF1ED&devi=34f90112fe774df2accfe8a07e65da8fc64585be&osversion=ios_11.400000&ua=iPhone10_1&imei=&imsi=&uid=168011&sid=20XvWhlzmkWzEAi1lsHxyY0hGYWQ9dcMVdLtKVxnepUOFW8DnUi3&conn=unknown&mtid=&mtxid=&logid=266,281,282,285,226,230&smid=D2IF6BklWVLQgxIpU6ER%2BSR5g0AGjMMo5oUG7BadHTvZ4Xd4&ast=1
//映客接口测试
-(void)yingke_requestTest{
    NSDictionary *dic = @{@"appid":@"BDAF6B4D-5DC0-4AEF-BCF8-6C7EFC94DE99"};
    SSRequest *request = [[SSRequest alloc]init];
    request.requestUrl = @"https://service.inke.cn/api/user_feed/recommend?gender=1&user_level=9&longitude=200&location=%2C%2C&offset=0&session_id=1534315285&latitude=200&lc=0000000000000107&cc=TG0001&cv=IK6.1.45_Iphone&proto=13&idfa=1C6E6DAE-E9CD-409E-9DE3-CE049F43D77C&idfv=310BD347-E30F-4848-87D5-FC35332AF1ED&devi=34f90112fe774df2accfe8a07e65da8fc64585be&osversion=ios_11.400000&ua=iPhone10_1&imei=&imsi=&uid=168011&sid=20XvWhlzmkWzEAi1lsHxyY0hGYWQ9dcMVdLtKVxnepUOFW8DnUi3&conn=unknown&mtid=&mtxid=&logid=266,281,282,285,226,230&smid=D2IF6BklWVLQgxIpU6ER%2BSR5g0AGjMMo5oUG7BadHTvZ4Xd4&ast=1";
    request.requestArgument = nil;
    request.requestMethod = YTKRequestMethodGET;
    request.requestSerializerType = YTKRequestSerializerTypeJSON;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
