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
            _pmDownloadManager = [[PMDownloadManager alloc]initWithRootPath:BJYPath];
            _pmDownloadManager.delegate = self;
        });
    }
    return _pmDownloadManager;
}

-(void)startDownload{
    //百家云直播回放
    NSString *webcastid = @"17081868624899";
    NSString *vodpassword = @"GqWb2ZbzIEWNcup-z1nfawQswJsIPG12KGoegVdZxYNGXzXK0HAAYw";
    NSString *seesion = @"201708180";
    NSString *vodTitleName = @"测试-01";

    [self.pmDownloadManager addDownloadWithClass:webcastid seesionID:@"" token:vodpassword definionArray:@[@0,@1,@2,@3] showFileName:vodTitleName];
}

#pragma mark - PMDownloadDelegate
- (void)startDownload:(PMDownloader *)downloader{
    
}

- (void)updateProgress:(PMDownloader *)downloader{
    NSLog(@"progress - %.2f",downloader.downloadModel.progress);
}

- (void)finishedDownload:(PMDownloader *)downloader{
    
}

- (void)downloadFail:(nullable PMDownloader *)downloader beforeDownloadError:(nullable NSError *)error{
    
}


@end
