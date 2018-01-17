//
//  BJLWebViewController.h
//  M9Dev
//
//  Created by MingLQ on 2017-05-31.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJLWebViewController : UIViewController {
@protected
    WKWebViewConfiguration *_configuration;
    WKWebView *_webView;
}

@property (nonatomic, readonly) WKWebView *webView; // [self.webView bjl_removeAllConstraints] to remove default constraints
/**
 [configuration.userContentController addScriptMessageHandler:scriptMessageHandler name:name];
 wtf: configuration.userContentController retains the scriptMessageHandler
 wtfScriptMessageHandler: wrap and weak reference to self
 */
@property (nonatomic, readonly) id<WKScriptMessageHandler> wtfScriptMessageHandler;
/**
 suffix append to default UserAgent and set to webView.customUserAgent
 */
@property (nonatomic, copy) NSString *userAgentSuffix;

- (instancetype)initWithConfiguration:(nullable WKWebViewConfiguration *)configuration NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
