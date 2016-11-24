//
//  GpuImageFirstViewController.m
//  Example
//
//  Created by 张鹏 on 16/6/27.
//  Copyright © 2016年 张鹏. All rights reserved.
//

#import "GpuImageFirstViewController.h"
#import "GPUImage.h"

@interface GpuImageFirstViewController ()
{
    CGFloat processingTimeForCPURoutine, processingTimeForCoreImageRoutine, processingTimeForGPUImageRoutine;
}
@end

@implementation GpuImageFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *inputImage = [UIImage imageNamed:@"IMG_0425.JPG"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imageView.image = [self imageProcessedUsingGPUImage:inputImage];
    [self.view addSubview:imageView];
    

}

- (UIImage *)imageProcessedUsingGPUImage:(UIImage *)imageToProcess{
    CFAbsoluteTime elapsedTime, startTime = CFAbsoluteTimeGetCurrent();
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:imageToProcess];
    GPUImageSobelEdgeDetectionFilter *stillImageFilter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
    
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    
    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];
    
    elapsedTime = CFAbsoluteTimeGetCurrent() - startTime;
    processingTimeForGPUImageRoutine = elapsedTime * 1000.0;
    
    return currentFilteredVideoFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
