////
////  BaseViewController.h
////  ZhuanTiKu_GWY
////
////  Created by HuaTuYiDongXueXi on 16/6/16.
////  Copyright © 2016年 youbinbin. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//#import "ZTKTools.h"
//#import "ZTKNavgationController.h"
//#import "GVUserDefaults+ZTKUserDefaults.h"
//
//#import "ZTKAnswerNavBtnView.h"
//#import "ZTKAnalysisNavBtnView.h"
//
//#import "ZTKDraftPaperBtnBackView.h"
//
//#import "ZTKQuestionMoreView.h"
//#import "ZTKErrorQuestionNavBtnView.h"
//#import "ZTKShowRuquestErrorImage.h"
//
//#import "ZTKAthleticPracticeNavBtnView.h"
//
//#import "ZTKStatistics.h"
//
//#define CleanVideo @"cleanVideo"
///**
// *  一次最多请求试题的数量。
// *  @return
// */
//#define MAXRequest 150
//
//typedef enum{
//    //_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_++_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_//
//    
//    //            NSArray *arr = @[@"类型不限",@"智能出题",@"专项练习",@"真题演练",@"智能模考",@"竞技练习",@"错题练习",@"每日训练",@"收藏练习",@"模考估分",@"砖超联赛"];
//    
//    //_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_++_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_//
//    /**
//     *  智能出题
//     */
//    IntelligentQuestionsType=0,
//    /**
//     *  错题
//     */
//    ErrorQuestionType,
//    /**
//     *  收藏，
//     */
//    CollectionType,
//    /**
//     *  真题，
//     */
//    TureQuestionType,
//    /**
//     * 模考
//     */
//    GuFenType,
//    /**
//     * 只能模考
//     */
//    IntelligentType,
//    /**
//     *  每日
//     */
//    EveryDayType,
//    /**
//     *  专项。
//     */
//    SpecialType,
//    
//    /**
//     *  竞技练习。
//     */
//    SportsType,
//    /**
//     *  专超海选
//     */
//    SuperSpecialType,
//    /**
//     * 类型不限
//     */
//    NomalType
//}PaperType;
//
//
//typedef enum{
//    /**
//     *  分享试题
//     */
//    QuestionType,
//    /**
//     *  练习报告分享。
//     */
//    PracticeReport,
//    /**
//     *  智能评估报告。
//     */
//    IntelligenceEvaluationReport,
//    /**
//     *  分享课程。
//     */
//    ShareCousreMessage,
//    /**
//     * 竞技排行
//     */
//    RankShare,
//    /**
//     * 竞技战绩
//     */
//    RankSummary,
//    
//    ///竞技成绩统计分享
//    SportsStatistics,
// 
//    /**
//     * 其他分享
//     */
//    OtherShare
//
//}ShareType;
//
//
//@interface BaseViewController : UIViewController
///**
// *  navtype;导航条类型。默认正常。
// */
//@property (nonatomic,assign)PaperType type;
///**
// *  是否正在计时。
// */
//@property (nonatomic,assign)BOOL isTimer;
//
///**
// *  导航条的颜色。
// */
//@property (nonatomic,assign)TypeColor typeColor;
// 
///**
// *  答题导航按钮。 使用需要遵守协议
// */
//@property(nonatomic,retain) ZTKAnswerNavBtnView * answerNavBack;
///**
// *  解析导航按钮。 使用需要遵守协议
// */
//@property(nonatomic,retain) ZTKAnalysisNavBtnView * analysisNavBack;
///**
// *  竞技练习导航按钮。 使用需要遵守协议
// */
//@property(nonatomic,retain)ZTKAthleticPracticeNavBtnView * athleticPNavView;
//
///**
// *  显示错题解析。
// */
//@property (nonatomic,retain)ZTKErrorQuestionNavBtnView * errorNavBack;
//
///**
// *  草稿纸导航按钮。 使用需要遵守协议
// */
//@property(nonatomic,retain) ZTKDraftPaperBtnBackView * draftPaperNavBack;
//
//
///**
// *  更多。
// */
//@property (nonatomic,retain)ZTKQuestionMoreView * moreView;
//
///**
// *  修改导航条颜色。
// *
// *  @param type
// */
//-(void)changeNavigtionBackColor:(TypeColor)type;
///**
// *  显示草稿纸按钮。
// */
//-(void)showDraftPaperBtn;
///**
// *  显示做题页面的导航条
// */
//-(void)showAnswerNavBtn;
///**
// *  显示解析页面导航条。
// */
//-(void)showAnalysisNavBtn;
///**
// *  显示错题解析。
// */
//-(void)showErrorNavBtn;
///**
// *  显示竞技练习。
// */
//-(void)showathleticPNavBtn;
//
///**
// *  显示更多。 是否收藏。
// */
//-(void)showMoreViewWithCollection:(BOOL)isCollection;
///**
// *  关闭更多。
// */
//-(void)closeMoreView;
//
///**
// *  开始计时。
// */
//
//-(void)startTimer;
///**
// *  停止计时 并且显示 等待页
// */
//-(void)endTimer;
//
///**
// *  停止计时不显示 等待页。
// *
// */
//-(void)stopTimer;
//
///**
// *  更新时间相关。
// */
//-(void)timeUpdate;
//
///**
// *  得到时间字符串。
// *
// *  @param second 秒。
// *
// *  @return 时间如  00：04；
// */
//-(NSString*)getTimerStringWithSecond:(long long)times;
///**
// * 得到做题页面还有答题解析页面的 umeng统计。类型。
// *  @param type
// *  @return
// */
//-(NSString*)getUmengId:(PaperType)type;
//
///**
// *  显示分享view
// */
//-(void)shareViewShowQuestionId:(NSString *)questionId type:(ShareType)type;
//
/////其他分享。
//-(void)shareWithTitle:(NSString*)title content:(NSString*)content url:(NSString*)url;
//
//
//@end
