//
//  BJPChatMessageTableViewCell.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/23.
//
//

#import <UIKit/UIKit.h>
#import <BJPlaybackCore/BJPlaybackCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPChatMessageTableViewCell : UITableViewCell

@property (nonatomic, readonly) UIImageView *imgView;
@property (nonatomic, copy, nullable) void (^updateCellConstraintsCallback)(BJPChatMessageTableViewCell * _Nullable cell);

+ (NSArray<NSString *> *)allCellIdentifiers;
+ (NSString *)cellIdentifierForMessageType:(BJLMessageType)type;
+ (CGFloat)estimatedRowHeightForMessageType:(BJLMessageType)type;

- (void)updateWithMessage:(BJLMessage *)message
              placeholder:(nullable UIImage *)placeholder
           tableViewWidth:(CGFloat)tableViewWidth;


@end

NS_ASSUME_NONNULL_END
