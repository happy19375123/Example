//
//  FenbiViewController.m
//  Example
//
//  Created by huatu on 2017/7/5.
//  Copyright © 2017年 张鹏. All rights reserved.
//

#import "FenbiViewController.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "FenbiLectureModel.h"
#import "FenbiDataStorage.h"

@interface FenbiViewController ()
{
    NSTimer *_timer;
}

@end

@implementation FenbiViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _timer = [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(requestFenbiLiveList) userInfo:nil repeats:YES];
}

-(void)requestFenbiLiveList{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    manager.requestSerializer.timeoutInterval = 0.20f;
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dic = @{};
    [manager GET:@"http://ke.fenbi.com/iphone/gwy/v3/content?app=gwy&system=10.2&av=3&kav=3&version=6.2.0&cat=0&len=30&start=0" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        NSString *date = [self dateByNow];
        NSMutableArray *mArray = [[NSMutableArray alloc]init];
        NSArray *dataArray = [responseObject objectForKey:@"datas"];
        for(NSDictionary *obj in dataArray){
            NSDictionary *dic = obj[@"lectureSummary"];
            if([dic isKindOfClass:[NSNull class]]){
                dic = obj[@"lectureSetSummary"];
            }
            FenbiLectureModel *model = [[FenbiLectureModel alloc]initWithDic:dic];
            model.date = date;
            [mArray addObject:model];
        }
        for(FenbiLectureModel *model in mArray){
            [[FenbiDataStorage instance] insert_schoolinfo:model];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"faulure");
    }];
}

-(NSString *)dateByNow{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
