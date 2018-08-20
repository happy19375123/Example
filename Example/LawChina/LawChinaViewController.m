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
#import <MJExtension/MJExtension.h>
#import "LawDataRequestTool.h"
#import "LawEffectLevelRequestTool.h"

@interface LawChinaViewController ()

@property(nonatomic,strong) FMDatabase *db;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger lawID;
@property(nonatomic,strong) NSMutableDictionary *mDic;

@end

@implementation LawChinaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configdefaultData];
    
    //[self loadDB];
    //[self loadDataSource];
    //[self requestLawInfoWithPageIndex:1];
    
    //请求单个法律信息
    //403332,403326
    //[self requestLawID:395414];
    
    //请求范围ID
    //[self runLoopRequestLawDataWithLawID:401900 endLawID:402000];
    
    //获取对应法律效力下的法律ID，并保存
    //[self requestLawIDWithEffectiveLevel:2];
    
    //获取对应法律效力下的法律信息
    [self requestLawDataWithEffectLevel:2 index:0];
}


-(void)configdefaultData{
    //398931 -
    //402667 - 正常
    //402777 - 决定或单条解释
    //400279 - 司法解释
    //self.lawID = 398931;
    self.lawID = 396545;
    self.mDic = [[NSMutableDictionary alloc]init];
}

#pragma mark - 根据法律ID请求法律信息
-(void)runLoopRequestLawDataWithLawID:(NSInteger )lawID endLawID:(NSInteger )endLawID{
    if(lawID > endLawID){
        //结束请求
        return;
    }
    
    LawDataRequestTool *tool = [[LawDataRequestTool alloc]init];
    [tool requestLawDataWithLawID:lawID resultBlock:^(NSDictionary *resultDic, NSError * _Nullable error) {
        NSInteger errorcode = [resultDic[@"errorcode"] integerValue];
        NSString *msg = resultDic[@"msg"];
        if(errorcode == 100000){
            //请求成功
            NSString *path = resultDic[@"path"];
            LawModel *model = resultDic[@"model"];
            NSLog(@"path - %@",path);
            [self runLoopRequestLawDataWithLawID:lawID+1 endLawID:endLawID];
        }else{
            NSLog(@"%@",msg);
            [self runLoopRequestLawDataWithLawID:lawID+1 endLawID:endLawID];
        }
    }];
}

-(void)requestLawID:(NSInteger )lawID{
    LawDataRequestTool *tool = [[LawDataRequestTool alloc]init];
    [tool requestLawDataWithLawID:lawID resultBlock:^(NSDictionary *resultDic, NSError * _Nullable error) {
        NSInteger errorcode = [resultDic[@"errorcode"] integerValue];
        NSString *msg = resultDic[@"msg"];
        if(errorcode == 100000){
            //请求成功
            NSString *path = resultDic[@"path"];
            LawModel *model = resultDic[@"model"];
            NSLog(@"path - %@",path);
        }else{
            NSLog(@"%@",msg);
        }
    }];

}

-(void)requestLawDataWithEffectLevel:(NSInteger )level index:(NSInteger )index{
    NSString *levelPath = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"txt"];
    NSMutableArray *baseArray = [NSMutableArray arrayWithContentsOfFile:levelPath];
    
    if(baseArray.count <= index){
        //结束请求
        return;
    }
    
    NSMutableArray *concurrentArray = [[NSMutableArray alloc]init];
    if(baseArray.count > 100){
        //并发数
        NSInteger concurrentCount = 5;
        NSInteger partCount = baseArray.count/concurrentCount;
        NSInteger startIndex = 0;
        for(int i=0;i<concurrentCount;i++){
            NSArray *obj = [baseArray subarrayWithRange:NSMakeRange(startIndex, partCount)];
            [concurrentArray addObject:obj];
            startIndex = startIndex + partCount;
        }
        
        if(startIndex < baseArray.count){
            NSInteger endPartCount = baseArray.count%concurrentCount;
            NSArray *obj = [baseArray subarrayWithRange:NSMakeRange(startIndex, endPartCount)];
            [concurrentArray addObject:obj];
        }
    }
    
    if(concurrentArray.count > 0){
        for(NSArray *array in concurrentArray){
            [self requestLawDataWithLawIDArray:array index:index];
        }
    }else{
        [self requestLawDataWithLawIDArray:baseArray index:index];
    }
}

-(void)requestLawDataWithLawIDArray:(NSArray *)array index:(NSInteger )index{
    if(array.count <= index){
        //结束请求
        return;
    }
    
    NSInteger lawID = [array[index] integerValue];
    
    LawDataRequestTool *tool = [[LawDataRequestTool alloc]init];
    [tool requestLawDataWithLawID:lawID resultBlock:^(NSDictionary *resultDic, NSError * _Nullable error) {
        NSInteger errorcode = [resultDic[@"errorcode"] integerValue];
        NSString *msg = resultDic[@"msg"];
        if(errorcode == 100000){
            //请求成功
            NSString *path = resultDic[@"path"];
            NSLog(@"path - %@",path);
        }else{
            NSLog(@"%@",msg);
        }
        [self requestLawDataWithLawIDArray:array index:index+1];
    }];
}

#pragma mark - 根据法律效力请求法律ID
-(void)requestLawIDWithEffectiveLevel:(NSInteger )level{
    LawEffectLevelRequestTool *tool = [[LawEffectLevelRequestTool alloc]init];
    [tool requestLawInfoWithPageIndex:1 resultBlock:^(NSDictionary *resultDic, NSError * _Nullable error) {
        NSInteger errorcode = [resultDic[@"errorcode"] integerValue];
        NSString *msg = resultDic[@"msg"];
        if(errorcode == 100000){
            //请求成功
            NSString *path = resultDic[@"path"];
            NSLog(@"path - %@",path);
        }else{
            NSLog(@"%@",msg);
        }
    }];
}

#pragma mark - DB
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

#pragma mark - Timer

-(void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestLawInfo) userInfo:nil repeats:YES];
}

@end
