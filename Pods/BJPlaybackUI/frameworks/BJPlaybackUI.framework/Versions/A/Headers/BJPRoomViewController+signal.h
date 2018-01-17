//
//  BJPRoomViewController+signal.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/28.
//
//

#import <BJPlaybackUI/BJPlaybackUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPRoomViewController (signal)

- (void)addNotification;

//监听进入房间的时候是否成功
- (void)roomEnterSignal;

- (NSString *)timeWithTime:(NSTimeInterval)interval;

@end

NS_ASSUME_NONNULL_END
