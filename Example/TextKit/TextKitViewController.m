//
//  TextKitViewController.m
//  Example
//
//  Created by 张鹏 on 16/6/30.
//  Copyright © 2016年 张鹏. All rights reserved.
//

#import "TextKitViewController.h"
#import "HPTextViewTapGestureRecognizer.h"

@interface TextKitViewController ()<HPTextViewTapGestureRecognizerDelegate>

@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,strong) NSArray *imageArray;
@property(nonatomic,strong) NSArray *indexArray;
@property(nonatomic,strong) HPTextViewTapGestureRecognizer *textViewTapGestureRecognizer;

@end

@implementation TextKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"普通文字排版&表情混排";
    
    
    //初始化textView
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 40 - 44 - 20)];
    self.textView.backgroundColor = [UIColor cyanColor];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.textView.text = @"<p>123</p><p>456</p><p>sadfsadfsdfasdf</p>我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才我是天才";
    
    self.textView.attributedText = [[NSMutableAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.textView.font = [UIFont systemFontOfSize:15];
    
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    
    //设置常规属性
   
    
    //链接和表情
//    [self setupEmojiAndLink];
    self.textView.editable = NO;
    self.textView.selectable = YES;
//    [self setupNormalAttribute];
    
    self.textViewTapGestureRecognizer = [[HPTextViewTapGestureRecognizer alloc]init];
    [self.textView addGestureRecognizer:self.textViewTapGestureRecognizer];
    self.textViewTapGestureRecognizer.delegate = self;
}


/**
 *  向文本中添加表情，链接等
 */
- (void)setupEmojiAndLink{
    
//    NSMutableAttributedString * mutStr = [self.textView.attributedText mutableCopy];
    
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithData:[self.textView.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //添加表情
    UIImage * image1 = [UIImage imageNamed:@"Icon"];
    NSTextAttachment * attachment1 = [[NSTextAttachment alloc] init];
    attachment1.bounds = CGRectMake(0, 0, 10, 10);
    attachment1.image = image1;
    NSAttributedString * attachStr1 = [NSAttributedString attributedStringWithAttachment:attachment1];
    [mutStr insertAttributedString:attachStr1 atIndex:50];
    
    //添加表情
    UIImage * image2 = [UIImage imageNamed:@"Icon"];
    NSTextAttachment * attachment2 = [[NSTextAttachment alloc] init];
    attachment2.bounds = CGRectMake(0, 0, image2.size.width, image2.size.height);
    attachment2.image = image2;
    NSAttributedString * attachStr2 = [NSAttributedString attributedStringWithAttachment:attachment2];
    [mutStr insertAttributedString:attachStr2 atIndex:52];
    
    //添加链接
    NSURL * url = [NSURL URLWithString:@"http://www.baidu.com"];
    [mutStr addAttribute:NSLinkAttributeName value:url range:NSMakeRange(70, 10)];
    
    self.textView.attributedText = [mutStr copy];
}

/**
 *  设置常规属性
 */
- (void)setupNormalAttribute{
    NSMutableAttributedString * mutStr = [self.textView.attributedText mutableCopy];
    
    //颜色
    [mutStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(10, 10)];
    //字体
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(20, 5)];
    //下划线
    [mutStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle | NSUnderlinePatternDot) range:NSMakeRange(32, 8)];
    //空心字
    [mutStr addAttribute:NSStrokeWidthAttributeName value:@(2) range:NSMakeRange(42, 5)];
    self.textView.attributedText = [mutStr copy];
}

/**
 *  点击图片触发代理事件
 */
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    NSLog(@"%@", textAttachment);
    return NO;
}

/**
 *  点击链接，触发代理事件
 */
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    [[UIApplication sharedApplication] openURL:URL];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark HPTextViewTapGestureRecognizerDelegate

-(void)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer handleTapOnURL:(NSURL*)URL inRange:(NSRange)characterRange
{
    NSArray *syms = [NSThread  callStackSymbols];
    [[UIApplication sharedApplication] openURL:URL];
    
}

-(void)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer handleTapOnTextAttachment:(NSTextAttachment*)textAttachment inRange:(NSRange)characterRange
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Woof!", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
}

-(void)dealloc{
    
}

@end
