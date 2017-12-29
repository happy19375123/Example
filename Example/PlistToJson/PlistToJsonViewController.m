//
//  PlistToJsonViewController.m
//  Example
//
//  Created by Sseakom on 2017/11/30.
//  Copyright © 2017年 张鹏. All rights reserved.
//

#import "PlistToJsonViewController.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

@interface PlistToJsonViewController ()

@property(nonatomic,strong) NSMutableArray *treeArray;    //知识树结构数组
@property(nonatomic,strong) NSMutableArray *dataArray;    //题库后台返回的知识点数组，用来获取知识点ID
@property(nonatomic,strong) NSMutableArray *resultArray;  //结果数组

@end

@implementation PlistToJsonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self plistToJson];
    [self request];
    [self initViews];
}

-(void)initData{
    _treeArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _resultArray = [[NSMutableArray alloc]init];
}

-(void)initViews{
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)plistToJson{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tree" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    [_treeArray addObjectsFromArray:array];
}

-(void)request{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    manager.requestSerializer.timeoutInterval = 0.20f;
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dic = @{@"appid":@"BDAF6B4D-5DC0-4AEF-BCF8-6C7EFC94DE99"};
    [manager GET:@"http://ns.huatu.com/k/v1/points/100100126" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        NSArray *dataArray = responseObject[@"data"];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:dataArray];
        [self merge];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"faulure");
    }];
}

-(void)merge{
    for(NSDictionary *firstLevelDic in _treeArray){
        NSMutableDictionary *levelonePointDic = [[NSMutableDictionary alloc]init];
        NSString *name = firstLevelDic[@"name"];
        NSString *levelonePointid = [self searchPointIDWithName:name];
        [levelonePointDic setObject:levelonePointid forKey:@"id"];
        [levelonePointDic setObject:name forKey:@"name"];
        [levelonePointDic setObject:@"0" forKey:@"level"];
        [levelonePointDic setObject:@"-1" forKey:@"parent"];
        NSMutableArray *leveloneChildArray = [[NSMutableArray alloc]init];
        [levelonePointDic setObject:leveloneChildArray forKey:@"children"];
        [_resultArray addObject:levelonePointDic];
        for(NSDictionary *secondLevelDic in firstLevelDic[@"child"]){
            NSMutableDictionary *leveltwoPointDic = [[NSMutableDictionary alloc]init];
            NSString *name = secondLevelDic[@"name"];
            NSString *leveltwoPointid = [self searchPointIDWithName:name];
            [leveltwoPointDic setObject:leveltwoPointid forKey:@"id"];
            [leveltwoPointDic setObject:name forKey:@"name"];
            [leveltwoPointDic setObject:@"1" forKey:@"level"];
            [leveltwoPointDic setObject:levelonePointid forKey:@"parent"];
            NSMutableArray *leveltwoChildArray = [[NSMutableArray alloc]init];
            [leveltwoPointDic setObject:leveltwoChildArray forKey:@"children"];
            [leveloneChildArray addObject:leveltwoPointDic];
            
            for(NSDictionary *threeLevelDic in secondLevelDic[@"child"]){
                NSMutableDictionary *levelthreePointDic = [[NSMutableDictionary alloc]init];
                NSString *name = threeLevelDic[@"name"];
                NSString *levelthreePointid = [self searchPointIDWithName:name];
                [levelthreePointDic setObject:levelthreePointid forKey:@"id"];
                [levelthreePointDic setObject:name forKey:@"name"];
                [levelthreePointDic setObject:@"2" forKey:@"level"];
                [levelthreePointDic setObject:leveltwoPointid forKey:@"parent"];
                NSMutableArray *levelthreeChildArray = [[NSMutableArray alloc]init];
                [levelthreePointDic setObject:levelthreeChildArray forKey:@"children"];
                [leveltwoChildArray addObject:levelthreePointDic];
            }
        }
    }
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
    [mDic setObject:@"1" forKey:@"code"];
    [mDic setObject:_resultArray forKey:@"data"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mDic options:0 error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
       //获取路径
    //写入plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:@"knowledgeTree_htfi.plist"];   //获取路径
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"knowledgeTree_htfi" ofType:@"plist"];
    [_resultArray writeToFile:filename atomically:YES];
    NSString *jsonStringfilename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"knowledgeTree.txt"];
    [jsonString writeToFile:jsonStringfilename atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(NSString *)searchPointIDWithName:(NSString *)name{
    for(NSDictionary *obj in _dataArray){
        if([name isEqualToString:obj[@"name"]]){
            return [NSString stringWithFormat:@"%@",obj[@"id"]];
        }
    }
    NSLog(@"name = %@ 没有查到ID",name);
    return [self pointIDForFinance];
}

-(NSString *)pointIDForFinance{
    static NSInteger fi_id= 0;
    fi_id++;
    return [NSString stringWithFormat:@"fi_%ld",(long)fi_id];
}

@end
