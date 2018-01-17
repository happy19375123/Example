//
//  BJPlayerDefinitionView.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/27.
//
//

#import <UIKit/UIKit.h>
#import <BJPlaybackCore/BJPlaybackCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPlayerDefinitionView : UIView

@property (nonatomic, copy, nullable) void (^definitionCallback)(PMVideoDefinitionInfoModel *sender);
@property (nonatomic, copy, nullable) void (^definitionCancelCallback)();


- (instancetype)initWithDefinitionList:(NSArray <__kindof PMVideoDefinitionInfoModel*> *)definitionList
                     currentDefinition:(PMVideoDefinitionInfoModel *)currentDefinition isHorizontal:(BOOL)isHorizontal;

- (void)updateConstraintForHorizontal:(BOOL)isHorizontal;

@end

NS_ASSUME_NONNULL_END
