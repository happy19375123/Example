////
////  BaseUINavigatiomViewController.m
////  ZhuanTiKu_GWY
////
////  Created by 鑫鑫 on 16/6/21.
////  Copyright © 2016年 youbinbin. All rights reserved.
////
//
//#import "BaseUINavigatiomViewController.h"
//
//// 导航条颜色
//#define CommonColor [GrayColor(255) colorWithAlphaComponent:1]
//
//@interface BaseUINavigatiomViewController ()
//
//
//@end
//
//@implementation BaseUINavigatiomViewController
//
////此方法，会在CZNavController当前类，执行第一个方法之前先会执行一次，并且只会调用一次
//+ (void)initialize{
//    //设置导航条的样式
////    UINavigationBar *navBar = [UINavigationBar appearance];
//    //UIBarMetricsDefault  背景图片 在横竖屏都显示
////    [navBar setBackgroundImage:[UIImage imageNamed:@"login_up"] forBarMetrics:UIBarMetricsDefault];
//    //设置标题的颜色
////    [navBar  setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor  whiteColor]}];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    
//    
//}
//
////重写导航控制器的push方法，每一个子控制器在跳转的时候都会调用此方法
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    //viewController  就是子控制器，设置子控制器的自定义后退按钮
//    
//    //1  自定义后退按钮
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage resizableImageNamed:@"dl_back-1"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
//    
//    //
//    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    fixedItem.width = -10;
//    
//    viewController.navigationItem.leftBarButtonItems = @[fixedItem,backItem];
//    
//    //自定义后退按钮后，手势返回上一级控制器的功能恢复
//    self.interactivePopGestureRecognizer.delegate = nil;
//    
//    //当push的时候隐藏tabBar
//    viewController.hidesBottomBarWhenPushed = YES;
//    
//    //真正的做了控制器之间的跳转
//    [super pushViewController:viewController animated:animated];
//    
//    
//    
////    if (self.viewControllers.count > 0) {
////        viewController.hidesBottomBarWhenPushed = YES;
////    }
////    [super pushViewController:viewController animated:animated];
//}
//- (void)backClick{
//    [self popViewControllerAnimated:YES];
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(BOOL)shouldAutorotate
//{
//    return [self.viewControllers.lastObject shouldAutorotate];
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return [self.viewControllers.lastObject supportedInterfaceOrientations];
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
//}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return toInterfaceOrientation == UIDeviceOrientationPortrait;
//}
//
//@end
