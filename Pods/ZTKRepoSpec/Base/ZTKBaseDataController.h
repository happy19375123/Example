////
////  ZTKBaseDataController.h
////  ZhuanTiKu_GWY
////
////  Created by HuaTuYiDongXueXi on 16/6/23.
////  Copyright © 2016年 youbinbin. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import "ZTKBaseNetRequest.h"
//
//@protocol ZTKBaseDataController <NSObject>
//
//@optional
///** 获取更多 */
//- (void)getMoreDataCompletionHandle:(void(^)(NSError *error))completed;
///** 刷新 */
//- (void)refreshDataCompletionHandle:(void(^)(NSError *error))completed;
///** 获取数据 */
//- (void)getDataCompletionHandle:(void(^)(NSError *error))completed;
///** 通过indexPath返回cell高*/
//- (float)cellHeightForIndexPath:(NSIndexPath *)indexPath;
//
//@end
//@interface ZTKBaseDataController : NSObject
//@property (nonatomic,strong) NSURLSessionDataTask *dataTask;
//@property(nonatomic,strong) NSMutableArray *dataArr;
///**  取消任务 */
//- (void)cancelTask;
///**  暂停任务 */
//- (void)suspendTask;
///**  继续任务 */
//- (void)resumeTask;
//@end
