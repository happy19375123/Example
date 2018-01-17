//
//  UIAlertController+BJLAddAction.h
//  M9Dev
//
//  Created by MingLQ on 2017-01-20.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (BJLAddAction)

- (UIAlertAction *)bjl_addActionWithTitle:(nullable NSString *)title
                                    style:(UIAlertActionStyle)style
                                  handler:(void (^ _Nullable)(UIAlertAction *action))handler;

@end

NS_ASSUME_NONNULL_END
