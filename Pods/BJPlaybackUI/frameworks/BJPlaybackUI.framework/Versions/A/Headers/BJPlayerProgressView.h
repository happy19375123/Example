//
//  BJPlayerProgressView.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/23.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BJPlayerSlider;

@interface BJPlayerProgressView : UIView

@property (nonatomic, readonly) BJPlayerSlider *slider;

-(void)setValue:(float)value cache:(float)cache duration:(float)duration;

@end

@interface BJPlayerSlider : UISlider

@end

NS_ASSUME_NONNULL_END
