//
//  BJLTableViewController.h
//  M9Dev
//
//  Created by MingLQ on 2017-02-13.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 BJLTableViewController, differences from UITableViewController:
 0. self.view is UIView, self.tableView is a subview of self.view
 1. self.tableView.cellLayoutMarginsFollowReadableWidth is NO by default
 2. self.tableView.dataSource/delegate will be auto-set(loadView) and auto-reset(dealloc) if self conformsToProtocol: <UITableViewDataSource>/<UITableViewDelegate>
 3. returns CGFLOAT_MIN for header/footer height and nil for header/footer view by default
 TODO: BJLCollectionViewController
 */
@interface BJLTableViewController : UIViewController {
@protected
    UITableView *_tableView;
}

@property (nonatomic, readonly) UITableViewStyle tableViewStyle; // UITableViewStylePlain by default
@property (nonatomic, readonly) UITableView *tableView; // [self.tableView bjl_removeAllConstraints] to remove default constraints
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

@property (nonatomic, nullable) UIRefreshControl *refreshControl;

- (instancetype)initWithStyle:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
