//
//  BJPChatMessageViewController.h
//  Pods
//
//  Created by 辛亚鹏 on 2017/8/23.
//
//

#import <UIKit/UIKit.h>
#import <BJPlaybackCore/BJPlaybackCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPChatMessageViewController : UIViewController

@property (nonatomic) NSMutableArray<__kindof BJLMessage *> *allMessages;
@property (nonatomic, copy, nullable) void (^showBigImageViewCallback)(UIImageView *imageView);

@property (nonatomic, readonly) UITableView *tableView;

- (instancetype)initWithRoom:(BJPRoom *)room;

@end

NS_ASSUME_NONNULL_END
