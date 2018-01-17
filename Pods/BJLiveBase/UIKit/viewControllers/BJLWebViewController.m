//
//  BJLWebViewController.m
//  M9Dev
//
//  Created by MingLQ on 2017-05-31.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import "BJLWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BJLWTFScriptMessageHandler : NSObject <WKScriptMessageHandler>
@property (nonatomic, weak) id<WKScriptMessageHandler> handler;
@end
@implementation BJLWTFScriptMessageHandler
+ (instancetype)weakifyHandler:(id<WKScriptMessageHandler>)handler {
    BJLWTFScriptMessageHandler *wrapper = [self new];
    wrapper.handler = handler;
    return wrapper;
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([self.handler respondsToSelector:_cmd]) {
        [self.handler userContentController:userContentController didReceiveScriptMessage:message];
    }
}
@end

#pragma mark -

@interface BJLWebViewController ()

@property (nonatomic, readwrite) WKWebView *webView;
@property (nonatomic, copy) NSString *defaultUserAgent;

@end

@implementation BJLWebViewController {
    id<WKScriptMessageHandler> _wtfScriptMessageHandler;
}

- (instancetype)init {
    return [self initWithConfiguration:nil];
}

- (instancetype)initWithConfiguration:(nullable WKWebViewConfiguration *)configuration {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self->_configuration = configuration;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self webView];
}

- (id<WKScriptMessageHandler>)wtfScriptMessageHandler {
    if (!self->_wtfScriptMessageHandler) {
        self->_wtfScriptMessageHandler = [BJLWTFScriptMessageHandler weakifyHandler:(id<WKScriptMessageHandler>)self];
    }
    return self->_wtfScriptMessageHandler;
}

#pragma mark -

@synthesize webView = _webView;
- (WKWebView *)webView {
    if (![self isViewLoaded]) {
        [self view];
    }
    if (_webView) {
        return _webView;
    }
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                            configuration:self->_configuration ?: [WKWebViewConfiguration new]];
    self->_configuration = nil;
    if ([self conformsToProtocol:@protocol(WKNavigationDelegate)]) {
        webView.navigationDelegate = (id<WKNavigationDelegate>)self;
    }
    if ([self conformsToProtocol:@protocol(WKUIDelegate)]) {
        webView.UIDelegate = (id<WKUIDelegate>)self;
    }
    
    [self.view addSubview:webView];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view
     addConstraints:@[[NSLayoutConstraint
                       constraintWithItem:webView
                       attribute:NSLayoutAttributeLeft
                       relatedBy:NSLayoutRelationEqual
                       toItem:self.view
                       attribute:NSLayoutAttributeLeft
                       multiplier:1.0
                       constant:0.0],
                      [NSLayoutConstraint
                       constraintWithItem:webView
                       attribute:NSLayoutAttributeTop
                       relatedBy:NSLayoutRelationEqual
                       toItem:self.view
                       attribute:NSLayoutAttributeTop
                       multiplier:1.0
                       constant:0.0],
                      [NSLayoutConstraint
                       constraintWithItem:webView
                       attribute:NSLayoutAttributeRight
                       relatedBy:NSLayoutRelationEqual
                       toItem:self.view
                       attribute:NSLayoutAttributeRight
                       multiplier:1.0
                       constant:0.0],
                      [NSLayoutConstraint
                       constraintWithItem:webView
                       attribute:NSLayoutAttributeBottom
                       relatedBy:NSLayoutRelationEqual
                       toItem:self.view
                       attribute:NSLayoutAttributeBottom
                       multiplier:1.0
                       constant:0.0]]];
    
    self.webView = webView;
    
    typeof(self) __weak __weak_self__ = self;
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        typeof(__weak_self__) __strong self = __weak_self__;
        NSString *defaultUserAgent = [result isKindOfClass:[NSString class]] ? result : nil;
        self.defaultUserAgent = defaultUserAgent.length ? defaultUserAgent : @"-";
        [self makeCustomUserAgent];
    }];
    
    return _webView;
}

- (void)setUserAgentSuffix:(NSString *)userAgentSuffix {
    _userAgentSuffix = userAgentSuffix;
    [self makeCustomUserAgent];
}

- (void)makeCustomUserAgent {
    if (bjl_available(iOS 9.0, [self.webView respondsToSelector:@selector(setCustomUserAgent:)])) {
        if (self.userAgentSuffix.length) {
            if (self.defaultUserAgent.length) {
                self.webView.customUserAgent = [self.defaultUserAgent stringByAppendingFormat:@" %@", self.userAgentSuffix];
            }
            else {
                self.webView.customUserAgent = self.userAgentSuffix;
            }
        }
        else {
            if (self.webView.customUserAgent.length) {
                self.webView.customUserAgent = nil;
            }
        }
    }
}

#pragma mark - <WKUIDelegate>

- (void)runJavaScriptPanel:(UIAlertController *)alert {
    UIViewController *top = self;
    while (top.presentedViewController) {
        top = top.presentedViewController;
    }
    [top presentViewController:alert animated:NO completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler) completionHandler();
    }]];
    [self runJavaScriptPanel:alert];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *confirm = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [confirm addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler) completionHandler(YES);
    }]];
    [confirm addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler) completionHandler(NO);
    }]];
    [self runJavaScriptPanel:confirm];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)message defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    UIAlertController *prompt = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [prompt addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.returnKeyType = UIReturnKeyDone;
        textField.text = defaultText;
    }];
    typeof(prompt) __weak __weak_prompt__ = prompt;
    [prompt addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        typeof(__weak_prompt__) __strong prompt = __weak_prompt__;
        if (completionHandler) completionHandler(prompt.textFields.firstObject.text);
    }]];
    [prompt addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completionHandler) completionHandler(nil);
    }]];
    [self runJavaScriptPanel:prompt];
}

@end

NS_ASSUME_NONNULL_END
