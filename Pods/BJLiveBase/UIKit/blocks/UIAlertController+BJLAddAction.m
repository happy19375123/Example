//
//  UIAlertController+BJLAddAction.m
//  M9Dev
//
//  Created by MingLQ on 2017-01-20.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "UIAlertController+BJLAddAction.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIAlertController (BJLAddAction)

- (UIAlertAction *)bjl_addActionWithTitle:(nullable NSString *)title
                                    style:(UIAlertActionStyle)style
                                  handler:(void (^ _Nullable)(UIAlertAction *action))handler {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                     style:style
                                                   handler:handler];
    [self addAction:action];
    return action;
}

/*
- (void)bjl_setSourceView:(UIView *)view edge:(UIRectEdge)edge directions:(UIPopoverArrowDirection)directions {
    self.popoverPresentationController.sourceView = view;
    self.popoverPresentationController.sourceRect = ({
        CGRect rect = view.bounds;
        if (edge == UIRectEdgeTop) {
            rect.size.height = 1.0;
        }
        else if (edge == UIRectEdgeLeft) {
            rect.size.width = 1.0;
        }
        else if (edge == UIRectEdgeBottom) {
            rect.origin.y = CGRectGetMaxY(rect) - 1.0;
            rect.size.height = 1.0;
        }
        else if (edge == UIRectEdgeTop) {
            rect.origin.x = CGRectGetMaxX(rect) - 1.0;
            rect.size.width = 1.0;
        }
        rect;
    });
    self.popoverPresentationController.permittedArrowDirections = directions;
}
*/

@end

NS_ASSUME_NONNULL_END
