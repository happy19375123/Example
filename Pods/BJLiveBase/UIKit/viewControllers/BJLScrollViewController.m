//
//  BJLScrollViewController.m
//  M9Dev
//
//  Created by MingLQ on 2017-03-06.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "BJLScrollViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BJLScrollViewController ()

@property (nonatomic, readwrite) UIScrollView *scrollView;

@end

@implementation BJLScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self scrollView];
}

- (void)didMoveToParentViewController:(nullable UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    
    if (self.navigationController.interactivePopGestureRecognizer) {
        [_scrollView.panGestureRecognizer requireGestureRecognizerToFail:
         self.navigationController.interactivePopGestureRecognizer];
    }
}

#pragma mark -

@synthesize scrollView = _scrollView;
- (UIScrollView *)scrollView {
    if (![self isViewLoaded]) {
        [self view];
    }
    if (_scrollView) {
        return _scrollView;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view
     addConstraints:@[[NSLayoutConstraint
                       constraintWithItem:scrollView
                       attribute:NSLayoutAttributeLeft
                       relatedBy:NSLayoutRelationEqual
                       toItem:self.view
                       attribute:NSLayoutAttributeLeft
                       multiplier:1.0
                       constant:0.0],
                      [NSLayoutConstraint
                       constraintWithItem:scrollView
                       attribute:NSLayoutAttributeTop
                       relatedBy:NSLayoutRelationEqual
                       toItem:self.view
                       attribute:NSLayoutAttributeTop
                       multiplier:1.0
                       constant:0.0],
                      [NSLayoutConstraint
                       constraintWithItem:scrollView
                       attribute:NSLayoutAttributeRight
                       relatedBy:NSLayoutRelationEqual
                       toItem:self.view
                       attribute:NSLayoutAttributeRight
                       multiplier:1.0
                       constant:0.0],
                      [NSLayoutConstraint
                       constraintWithItem:scrollView
                       attribute:NSLayoutAttributeBottom
                       relatedBy:NSLayoutRelationEqual
                       toItem:self.view
                       attribute:NSLayoutAttributeBottom
                       multiplier:1.0
                       constant:0.0]]];
    
    self.scrollView = scrollView;
    return _scrollView;
}

- (void)setRefreshControl:(nullable UIRefreshControl *)refreshControl {
    NSString *key = NSStringFromSelector(@selector(refreshControl));
    [self willChangeValueForKey:key];
    if (self.refreshControl) {
        [self.refreshControl removeFromSuperview];
    }
    self->_refreshControl = refreshControl;
    if (refreshControl) {
        [self.scrollView insertSubview:refreshControl atIndex:0];
    }
    [self didChangeValueForKey:key];
}

@end

NS_ASSUME_NONNULL_END
