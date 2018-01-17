//
//  BJLScrollViewController.h
//  M9Dev
//
//  Created by MingLQ on 2017-03-06.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJLScrollViewController : UIViewController {
@protected
    UIScrollView *_scrollView;
}

@property (nonatomic, readonly) UIScrollView *scrollView; // [self.scrollView bjl_removeAllConstraints] to remove default constraints

@property (nonatomic, nullable) UIRefreshControl *refreshControl;

@end

NS_ASSUME_NONNULL_END
