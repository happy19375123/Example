////
////  BaseViewController.m
////  ZhuanTiKu_GWY
////
////  Created by HuaTuYiDongXueXi on 16/6/16.
////  Copyright © 2016年 youbinbin. All rights reserved.
////
//
//#import "BaseViewController.h"
//#import "ZTKTools.h"
//#import "ZTKDraftPaperBacKView.h"
//#import "ZTKAnswerPausePageView.h"
//#import "UMSocial.h"
//#import "ZTKBaseUrl.h"
//#import "ZTKCustomShareView.h"
//#import "ZTKShareDataController.h"
//
//@interface BaseViewController() <ZTKDraftPaperNavBtnViewDelegate,UMSocialUIDelegate>
//{
//    /**
//     *  倒计时。
//     */
//    dispatch_source_t _timer;
//    
//}
// 
///**
// *  草稿纸、
// */
//@property (nonatomic,retain)ZTKDraftPaperBacKView * draftPaper;
///**
// *  暂停背景
// */
//@property (nonatomic,retain)ZTKAnswerPausePageView * pausePage;
// 
//@end
//
//@implementation BaseViewController
//
//-(instancetype)init{
//    if (self=[super init]) {
//        self.typeColor=DayColor;
//        _type=NomalType;
//     }
//    return self;
//}
//
//-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        self.typeColor=DayColor;
//    }
//    return self;
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self createLeftBackBtn];
//    self.view.backgroundColor=DayBackgroundColor;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
// 
//    
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    [ZTKStatistics beginLogPageView:[NSString stringWithFormat:@"%@",[self class]]];
//    
////    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
//    [self changeNavigtionBackColor:_typeColor];
//    
//    
//
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    
//     [ZTKStatistics endLogPageView:[NSString stringWithFormat:@"%@",[self class]]];
//    [UIApplication sharedApplication].keyWindow.backgroundColor=self.view.backgroundColor;
//    [self cleanNavBtn];
//}
//
//-(void)createLeftBackBtn{
//    if (self.navigationController.viewControllers.count>1||self.navigationController.viewControllers.count==0) {
//        UIBarButtonItem * left=[ZTKTools createBarBtnItemWithTarget:self SLE:@selector(leftBarBtnClicks:) withImg:@"dl_back"];
//        self.navigationItem.leftBarButtonItem=left;
//        self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
//        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    }
//}
//
//-(void)leftBarBtnClicks:(UIBarButtonItem*)barbtn{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}
//
//
//-(void)changeNavigtionBackColor:(TypeColor)type{
//    ZTKNavgationController * ztkNavgationController =(ZTKNavgationController*)self.navigationController;
//    
//    if (type==DayColor) {
//        self.view.backgroundColor=DayBackgroundColor;
//    }else if(type==NightColor){
//        self.view.backgroundColor=NightBackgroundColor;
//    }
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
//    _typeColor=type;
//    [ztkNavgationController ChangebackGrondColor:type];
//}
//
////_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_++_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_//
//#pragma mark- lazy
//-(ZTKDraftPaperBtnBackView *)draftPaperNavBack{
//    if (!_draftPaperNavBack) {
//        CGRect rect=CGRectZero;
//        if (_type==SportsType) {
//            rect=CGRectMake(0, 0, self.view.width, 64);
//        }else{
//            rect=CGRectMake(0, 0, self.view.width, 44);
//        }
//        
//        _draftPaperNavBack=[[ZTKDraftPaperBtnBackView alloc]initWithFrame:rect];
//        _draftPaperNavBack.delegate=self;
//
//    }
// 
//    return _draftPaperNavBack;
//}
//
//-(ZTKAnswerNavBtnView *)answerNavBack{
//    if (!_answerNavBack) {
//        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]];
//        _answerNavBack=[[ZTKAnswerNavBtnView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
//    }
//    return _answerNavBack;
//}
//
//
//-(ZTKAthleticPracticeNavBtnView *)athleticPNavView{
//    if (!_athleticPNavView) {
//           self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]];
//        _athleticPNavView=[[ZTKAthleticPracticeNavBtnView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
//    }
//    return _athleticPNavView;
//}
//
//
//-(ZTKAnalysisNavBtnView *)analysisNavBack{
//    if (!_analysisNavBack) {
//            self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]];
//        _analysisNavBack=[[ZTKAnalysisNavBtnView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
//    }
//    return _analysisNavBack;
// 
//}
//
//
//-(ZTKErrorQuestionNavBtnView *)errorNavBack{
//    if (!_errorNavBack) {
//            self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]];
//        _errorNavBack=[[ZTKErrorQuestionNavBtnView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
//    }
//    return _errorNavBack;
//}
//
//
//-(ZTKAnswerPausePageView *)pausePage{
//    if (!_pausePage) {
//        Weak_Self;
//        _pausePage=[[ZTKAnswerPausePageView alloc]initWithCallBack:^(NSInteger index) {
//            [weakSelf closePausePage];
//        }];
//    }
//    return _pausePage;
//}
//
//
//#pragma mark lazyEnd
////_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_++_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_//
//
//-(ZTKQuestionMoreView *)moreView{
//    if(!_moreView){
//        if (_errorNavBack||_analysisNavBack) {
//            _moreView=[[ZTKQuestionMoreView alloc]initWithFrame:CGRectMake(0,0, self.view.width, self.view.height) withDoQuestion:NO];
//        }else{
//            _moreView=[[ZTKQuestionMoreView alloc]initWithFrame:CGRectMake(0,0, self.view.width, self.view.height) withDoQuestion:YES];
//        }
//    }
//    [self.view addSubview:_moreView];
//    return _moreView;
//}
//
//#pragma mark 做题等特殊的导航条。
//-(void)showErrorNavBtn{
//    [self cleanNavBtn];
//    self.navigationItem.titleView=self.errorNavBack;
//}
///**
// *  显示草稿纸按钮。
// */
//-(void)showDraftPaperBtn{
// 
//    [self cleanNavBtn];
//    self.navigationItem.titleView=self.draftPaperNavBack;
//    [self showDraftpaperButton];
// 
//}
//
//-(void)showathleticPNavBtn{
//
//    [self cleanNavBtn];
//    self.navigationItem.titleView=self.athleticPNavView;
// 
//}
//
///**
// *  显示做题页面的导航条
// */
//-(void)showAnswerNavBtn{
////    if(self.navigationController.navigationBar.hidden){
//    
//        [self cleanNavBtn];
////        [self.view addSubview:self.answerNavBack];
//   self.navigationItem.titleView=self.answerNavBack;
////    }
//  
//}
///**
// *  显示解析页面导航条。
// */
//-(void)showAnalysisNavBtn{
// 
//        [self cleanNavBtn];
//     self.navigationItem.titleView=self.analysisNavBack;
////    }
//}
//
///**
// *  清理掉所有的按钮。
// */
//-(void)cleanNavBtn{
//
//    [self closeMoreView];
//}
//
////_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_++_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_//
///**
// *  显示草稿纸。
// */
//-(void)showDraftpaperButton{
//    Weak_Self;
//    _draftPaper=[[ZTKDraftPaperBacKView alloc]initWithFrame:CGRectMake(0,0, self.view.width, self.view.height) withCallBack:^(BOOL canBack, BOOL forward, BOOL canClear) {
//        weakSelf.draftPaperNavBack.draftPaperBack.selected=canBack;
//        weakSelf.draftPaperNavBack.draftPaperForward.selected=forward;
//        weakSelf.draftPaperNavBack.draftPaperClear.selected=canClear;
//    }];
//    [self.view addSubview:_draftPaper];
// 
//}
//
//
//#pragma mark- delegate ZTKDraftPaperNavBtnViewDelegate
//-(void)draftPaperNavCloseBtnClick:(UIButton*)button{
//    [_draftPaper removeFromSuperview];
//    [self cleanNavBtn];
//    _draftPaper=nil;
//    _draftPaperNavBack.draftPaperBack.selected=NO;
//    _draftPaperNavBack.draftPaperForward.selected=NO;
//    _draftPaperNavBack.draftPaperClear.selected=NO;
// 
//    if (_answerNavBack) {
//        self.navigationItem.titleView=self.answerNavBack;
//    }else{
//        switch (_type) {
//            case ErrorQuestionType:
//                self.navigationItem.titleView=self.errorNavBack;
//                break;
//            case CollectionType:
//                self.navigationItem.titleView=self.analysisNavBack;
//                break;
//            case NomalType:
//                self.navigationItem.titleView=self.analysisNavBack;
//                break;
//            case SportsType:
//                self.navigationItem.titleView=self.athleticPNavView;
//                break;
//            default:
//                self.navigationItem.titleView=self.analysisNavBack;
//                break;
//        }
//    
//    }
//}
//-(void)draftPaperNavClearBtnClick:(UIButton*)button{
//    [_draftPaper clear];
//}
//-(void)draftPaperNavBackBtnClick:(UIButton*)button{
//    [_draftPaper revocation];
//}
//-(void)draftPaperNavForwardBtnClick:(UIButton*)button{
//    [_draftPaper refrom];
//}
//
////_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_++_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_//
//
//-(NSString*)getUmengId:(PaperType)type{
//    
//    NSString * string=@"";
//    switch (type) {
//            //     *  智能出题
//        case IntelligentQuestionsType:
//            string=@"IntelligentQuestions";
//            break;
//            //     *  错题
//        case ErrorQuestionType:
//             string=@"ErrorQuestion";
//            break;
//            //     *  收藏，
//        case CollectionType:
//            string=@"Collection";
//            break;
//            //     *  真题，
//        case TureQuestionType:
//             string=@"TureQuestion";
//            break;
//            //     * 模考
//        case GuFenType:
//             string=@"GuFen";
//            break;
//            //     * 只能模考
//        case IntelligentType:
//             string=@"Intelligent";
//            break;
//            //     *  每日
//        case EveryDayType:
//             string=@"EveryDa";
//            break;
//            //     *  专项。
//        case SpecialType:
//            string=@"Special";
//            break;
//            //     *  竞技练习。
//        case SportsType:
//             string=@"Sports";
//            break;
//            //     *  专超海选
//        case SuperSpecialType:
//            string=@"SuperSpecial";
//            break;
//            //     * 类型不限
//        case NomalType:
//            string=@"Nomal";
//            break;
//            
//        default:
//             string=@"Nomal";
//            break;
//    }
//    return string;
//}
//
////_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_++_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_//
//-(void)dealloc{
//    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//-(void)closePausePage{
//    [self.pausePage hide];
//    [self startTimer];
//}
//
//
///**
// *  开始计时。
// */
//-(void)startTimer{
//    Weak_Self;
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//        dispatch_source_set_event_handler(_timer, ^{
//  
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    weakSelf.isTimer=YES;
//                    [weakSelf timeUpdate];
//                });
//   
//        });
//        dispatch_resume(_timer);
// 
//}
//
///**
// *  停止计时
// */
//-(void)endTimer{
////    dispatch_resume(_timer);
//    dispatch_async(dispatch_get_main_queue(), ^{
//          dispatch_source_cancel(_timer);
//    });
// 
//    [self.pausePage show];
//    
//    self.isTimer=NO;
//}
//
//-(void)stopTimer{
//    if (_timer) {
//        dispatch_source_cancel(_timer);
//        
//        self.isTimer=NO;
//    }
//}
///**
// *  更新时间相关。
// */
//-(void)timeUpdate{
//    
//}
//
//#pragma mark - shareView; 分享。
//
//-(void)shareViewShowQuestionId:(NSString *)questionId type:(ShareType)type{
// 
//
//    ZTKShareDataController * data=[[ZTKShareDataController alloc]init];
//    [ZTKTools showHUD:@"正在加载..." andView:self.view];
//    Weak_Self;
//    switch (type) {
//        case QuestionType:{
//            [data getQuestionsShareWithId:questionId success:^(NSDictionary* object) {
//                [weakSelf showShareViewWithContent:object wityType:QuestionType];
//                
//            } failure:^(NSString *errorMessage) {
//                
//                 [ZTKTools showAlertText:errorMessage onView:weakSelf.view];
//            }];
//        }
//            break;
//        case PracticeReport:{
//            [data  getPracticeShareWithId:questionId Success:^(NSDictionary* object) {
//                [weakSelf showShareViewWithContent:object wityType:PracticeReport];
//                
//            } failure:^(NSString *errorMessage) {
//                [ZTKTools showAlertText:errorMessage onView:weakSelf.view];
//                
//            }];
//        }
//            break;
//        case IntelligenceEvaluationReport:
//        {
//            [data getMyreportShareSuccess:^(NSDictionary* object) {
//                [weakSelf showShareViewWithContent:object wityType:IntelligenceEvaluationReport];
//                
//            } failure:^(NSString *errorMessage) {
//                
//                 [ZTKTools showAlertText:errorMessage onView:weakSelf.view];
//            }];
//        }
//            break;
//            
//            
//     
//            
//        case RankShare:
//        {
//            [data getRankShareSuccess:^(NSDictionary* object) {
//                [weakSelf showShareViewWithContent:object wityType:RankShare];
//                
//            } failure:^(NSString *errorMessage) {
//                
//                [ZTKTools showAlertText:errorMessage onView:weakSelf.view];
//            }];
//        }
//            break;
//            
//        case RankSummary:
//        {
//            [data getRankSummaryShareSuccess:^(NSDictionary* object) {
//                [weakSelf showShareViewWithContent:object wityType:RankSummary];
//                
//            } failure:^(NSString *errorMessage) {
//                
//                [ZTKTools showAlertText:errorMessage onView:weakSelf.view];
//            }];
//        }
//            break;
//            
//        case ShareCousreMessage:
//        {
//            [data getCourseShareWithId:questionId  Success:^(NSDictionary* object) {
//                [weakSelf showShareViewWithContent:object wityType:ShareCousreMessage];
//                
//            } failure:^(NSString *errorMessage) {
//                
//                [ZTKTools showAlertText:errorMessage onView:weakSelf.view];
//            }];
//        }
//            break;
//            
//        case SportsStatistics:{
//            [data getSportsStatistics:questionId Success:^(id object) {
//                [weakSelf showShareViewWithContent:object wityType:ShareCousreMessage];
//            } failure:^(NSString *errorMessage) {
//                
//                [ZTKTools showAlertText:errorMessage onView:weakSelf.view];
//            }];
//        }
//        default:
//            break;
//    }
// 
//}
//
//
//-(void)shareWithTitle:(NSString *)title content:(NSString *)content url:(NSString *)url{
//    [self showShareViewWithContent:@{@"title":title,@"desc":content,@"url":url} wityType:OtherShare];
//}
//
//
//-(void)showShareViewWithContent:(NSDictionary*)dic wityType:(ShareType)type{
//    
//    NSString * wechatText=@"";
//    NSString * qqText=@"";
//    NSString * sinaText=@"";
//    NSString * url=@"";
//    UIImage * image=[UIImage imageNamed:@"180-180"];
//    
//    [ZTKTools hideHudWithView:self.view];
//    url=dic[@"url"];
//    wechatText=dic[@"title"];
//    qqText=wechatText;
//    sinaText=[NSString stringWithFormat:@"%@%@",qqText,url];
//    image=[UIImage imageNamed:@"180-180"];
////    if (type==QuestionType) {
////        
////          wechatText=dic[@"title"];
////          qqText=wechatText;
////          sinaText=[NSString stringWithFormat:@"%@%@",qqText,url];
////          image=[UIImage imageNamed:@"180-180"];
////        
////      }else if(type==PracticeReport){
//// 
////          wechatText=dic[@"title"];
////          qqText=wechatText;
////          sinaText=[NSString stringWithFormat:@"%@%@",qqText,url];
////          image=[UIImage imageNamed:@"180-180"];
//// 
////      }else if(type==IntelligenceEvaluationReport)
////      {
////          wechatText=dic[@"title"];
////          qqText=wechatText;
////          sinaText=[NSString stringWithFormat:@"%@%@",qqText,url];
////          image=[UIImage imageNamed:@"180-180"];
////      }
//
//    
//    
//    /**
//     *  自定义分享样式。
//     */
//    
//    //    Weak_Self;
//    //    [ZTKCustomShareView showShareViewCallBack:^(NSDictionary *data) {
//    //        switch (type) {
//    //            case QuestionType:
//    //                [weakSelf shareQuestion:data url:url title:title content:content];
//    //                break;
//    //            case PracticeReport:
//    //
//    //            case IntelligenceEvaluationReport:
//    //                [weakSelf shareReport:data url:url title:title content:content];
//    //                break;
//    //            default:
//    //                break;
//    //        }
//    //    }];
//    /**
//     *  隐藏自带提示。
//     */
//         [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
//    
//        [UMSocialData defaultData].extConfig.qqData.url =url;
//        [UMSocialData defaultData].extConfig.qqData.title =qqText;
//        [UMSocialData defaultData].extConfig.qqData.shareImage=image;
//    
//        [UMSocialData defaultData].extConfig.qzoneData.url =url;
//        [UMSocialData defaultData].extConfig.qzoneData.title =qqText;
//        [UMSocialData defaultData].extConfig.qzoneData.shareImage=image;
//    
//        [UMSocialData defaultData].extConfig.wechatSessionData.url=url;
//        [UMSocialData defaultData].extConfig.wechatSessionData.shareImage=image;
//        [UMSocialData defaultData].extConfig.wechatSessionData.title = wechatText;
//    
//        [UMSocialData defaultData].extConfig.wechatTimelineData.title = wechatText;
//         [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage=image;
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url=url;
//    
//        [UMSocialData defaultData].extConfig.wxMessageType=UMSocialWXMessageTypeWeb;
//    
//        [UMSocialData defaultData].extConfig.sinaData.shareText=sinaText;
//    
////        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:url];
//    
//        [UMSocialSnsService presentSnsIconSheetView:self
//                                             appKey:@"52b7eaef56240b18f2269572"
//                                          shareText:dic[@"desc"]
//                                         shareImage:nil
//                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
//                                           delegate:self];
//}
//
//
//#pragma mark- UMSocialUIdelegate
//
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    /*
//     UMSResponseCodeSuccess            = 200,        //成功
//     UMSREsponseCodeTokenInvalid       = 400,        //授权用户token错误
//     UMSResponseCodeBaned              = 505,        //用户被封禁
//     UMSResponseCodeFaild              = 510,        //发送失败（由于内容不符合要求或者其他原因）
//     UMSResponseCodeArgumentsError     = 522,        //参数错误,提供的参数不符合要求
//     UMSResponseCodeEmptyContent       = 5007,       //发送内容为空
//     UMSResponseCodeShareRepeated      = 5016,       //分享内容重复
//     UMSResponseCodeGetNoUidFromOauth  = 5020,       //授权之后没有得到用户uid
//     UMSResponseCodeAccessTokenExpired = 5027,       //token过期
//     UMSResponseCodeNetworkError       = 5050,       //网络错误
//     UMSResponseCodeGetProfileFailed   = 5051,       //获取账户失败
//     UMSResponseCodeCancel             = 5052,        //用户取消授权
//     UMSResponseCodeNotLogin           = 5053,       //用户没有登录
//     UMSResponseCodeNoApiAuthority     = 100031      //QQ空间应用没有在QQ互联平台上申请上传图片到相册的权限
//
//     */
//    //根据`responseCode`得到发送结果,如果分享成功
//    
////    DLog(@"%@",response.thirdPlatformUserProfile);
//    
//    NSString * string=@"";
//    
//    switch (response.responseCode) {
//        case UMSResponseCodeSuccess:
//            string=@"分享成功";
//            break;
//        case UMSResponseCodeFaild:
//            string=@"分享失败";
//            break;
//        case UMSResponseCodeCancel:
//            string=@"取消分享";
//            break;
//        case UMSResponseCodeNotLogin:
//            string=@"未登录";
//            break;
//        default:
//            string=[NSString stringWithFormat:@"分享失败code=%d",response.responseCode];
//            break;
//    }
//    
//    [ZTKTools showAlertText:string onView:self.view];
//}
//
//
////_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_++_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_//
///**
// *  创建按钮。
// 
// *  @return
// */
//-(UIButton *)createBarBtnItemWithTarget:(id)tarGet SLE:(SEL)selector buttonSize:(CGSize)size withNomalImg:(NSString *)nomal selectedImg:(NSString *)select withImageEdgeInsets:(NSInteger)leftRightNomal{
//    
//    
//    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame=CGRectMake(-20, 0,size.width,size.height);
//    UIImage * image=[UIImage imageNamed:nomal];
// 
//
//    [button setImage:image forState:UIControlStateNormal];
//    [button setImage:[ZTKTools getAlwaysOriginal:select] forState:UIControlStateSelected];
//    [button addTarget:tarGet action:selector forControlEvents:UIControlEventTouchUpInside];
// 
//    return button;
//}
//
//
////_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_++_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_//
//
//
//-(void)showMoreViewWithCollection:(BOOL)isCollection{
//    _moreView.collectionBtn.selected=isCollection;
//    [self.moreView show];
//}
//-(void)closeMoreView{
//    if (_moreView) {
//        [_moreView hide];
//    }
//}
//
//
//
////_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_++_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_//
//
//-(NSString *)getTimerStringWithSecond:(long long)times{
//
//    long long minute=times/60;
//    long  long  second=times%60;
//    NSString * minuteString=nil;
//    NSString * secondString=nil;
//    if (minute<10) {
//        minuteString=[NSString stringWithFormat:@"0%lld",minute];
//    }else{
//        minuteString=[NSString stringWithFormat:@"%lld",minute];
//    }
//    if (second<10) {
//        secondString=[NSString stringWithFormat:@"0%lld",second];
//    }else{
//        secondString=[NSString stringWithFormat:@"%lld",second];
//    }
//    return [NSString stringWithFormat:@"%@:%@",minuteString,secondString];
//}
//
////_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_++_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_//
//
//-(void)didReceiveMemoryWarning{
//    [super didReceiveMemoryWarning];
//    NSLog(@"%@ MemoryWarning",[self class]);
//}
//
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}
//
//-(BOOL)shouldAutorotate
//{
//    if ([UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortrait) {
//        return NO;
//    }
//    return YES;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//@end
