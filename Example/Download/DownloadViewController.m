//
//  DownloadViewController.m
//  Example
//
//  Created by Sseakom on 2017/11/13.
//  Copyright © 2017年 张鹏. All rights reserved.
//

#import "DownloadViewController.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

@interface DownloadViewController ()

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadfile];
}

-(void)downloadfile{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //测试 - http://ese4a5b0c6d6j2.pri.qiqiuyun.net/course-activity-78/20171128042933-p5nn4dkolk0g0k0k?attname=ReferenceCard.pdf&e=1512561716&token=ExRD5wolmUnwwITVeSEXDQXizfxTRp7vnaMKJbO-:K9lC6ezd_QNIIU-67BfQCuZb994=
    NSURL *url = [NSURL URLWithString:@"http://120.92.93.120/mapi_v2/Lesson/downMaterial?courseId=78&materialId=45"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/vnd.edusoho.v2+json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"764dy0at5r0gkww4s40os4goc8wcsww" forHTTPHeaderField:@"token"];

    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度 - %.0f％", downloadProgress.fractionCompleted * 100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载完成");
    }];
    [downloadTask resume];
}
/**
 *  根据文件的创建时间 设置保存到本地的路径
 *
 *  @param created  创建时间
 *  @param fileName 名字
 *
 *  @return
 */
-(NSString *)setPathOfDocumentsByfileName:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@",cachesDir,fileName];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if (![filemanager fileExistsAtPath:path]) {
        [filemanager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

@end
