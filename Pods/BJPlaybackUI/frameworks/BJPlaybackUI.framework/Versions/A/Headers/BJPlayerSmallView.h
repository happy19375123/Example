//
//  BJPlayerSmallView.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/23.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BJPSmallViewShowType) {
    BJPSmallViewShowType_Video = 0,
    BJPSmallViewShowType_PPT = 1,
};

@interface BJPlayerSmallView : UIView

- (void)setTeacherName:(NSString *)name;

@property (nonatomic, copy, nullable) void (^alertCallback)(void);
@property (nonatomic) BJPSmallViewShowType showType;

@property (nonatomic, readonly) UIImageView *placeholderImageView;
@property (nonatomic,readonly) UIButton *nameButton;

@end

NS_ASSUME_NONNULL_END
