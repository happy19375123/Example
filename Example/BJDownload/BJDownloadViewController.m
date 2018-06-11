//
//  BJDownloadViewController.m
//  Example
//
//  Created by Sseakom on 2018/1/29.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import "BJDownloadViewController.h"
#import <BJPlayerManagerCore/PMDownloadManager.h>

@interface BJDownloadViewController ()<PMDownloadDelegate>

//百家云下载管理类
@property(nonatomic,strong) PMDownloadManager *pmDownloadManager;

@end

@implementation BJDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *BJYPath = [NSString stringWithFormat:@"%@/bjy",path];
    if(![filemanager isExecutableFileAtPath:path]){
        [filemanager createDirectoryAtPath:BJYPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    self.pmDownloadManager;
    [self startDownload];
}

-(PMDownloadManager *)pmDownloadManager{
    if (!_pmDownloadManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSFileManager *filemanager = [NSFileManager defaultManager];
            NSString *BJYPath = [NSString stringWithFormat:@"%@/bjy",path];
            if(![filemanager isExecutableFileAtPath:path]){
                [filemanager createDirectoryAtPath:BJYPath withIntermediateDirectories:NO attributes:nil error:nil];
            }
            _pmDownloadManager = [PMDownloadManager downloadManagerWithRootPath:BJYPath];
            _pmDownloadManager.delegate = self;
        });
    }
    return _pmDownloadManager;
}

-(void)startDownload{
    //百家云直播回放
    NSString *webcastid = @"18012977218266";
    NSString *vodpassword = @"-hUPEVYHSWGS52C-DRj5zgkPQiPrRCpA3BWZWNK8AlSXc9GfsRv2Xw";
    NSString *seesion = @"201801290";
    NSString *vodTitleName = @"测试-01";
    [self.pmDownloadManager addDownloadWithClass:webcastid seesionID:@"" token:vodpassword definionArray:@[@0,@1,@2,@3,@4] showFileName:vodTitleName creatTime:@"123"];
}

#pragma mark - PMDownloadDelegate
- (void)startDownload:(PMDownloader *)downloader{
    
}

- (void)updateProgress:(PMDownloader *)downloader{
    static float p = 0;
    if(downloader.downloadModel.progress - p > 0.005){
        NSLog(@"progress - %.3f",downloader.downloadModel.progress);
        p = downloader.downloadModel.progress;
    }
}

- (void)finishedDownload:(PMDownloader *)downloader{
    
}

- (void)downloadFail:(nullable PMDownloader *)downloader beforeDownloadError:(nullable PMBeforeDownloadModel *)beforeDownloadModel{
    NSLog(@"beforeDownloadModel.error.code - %ld",beforeDownloadModel.error.code);
    if(beforeDownloadModel.error.code == -999){
        //文件正在下载
        [self.pmDownloadManager resume:beforeDownloadModel.classId sessionId:nil];
    }
}

@end
