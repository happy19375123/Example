//
//  BJLURLAction.h
//  M9Dev
//
//  Created by MingLQ on 2015-06-12.
//  Copyright (c) 2015 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <Foundation/Foundation.h>

#import "NSURL+BJL_M9Dev.h"
#import "NSInvocation+BJL_M9Dev.h"

NS_ASSUME_NONNULL_BEGIN

@interface BJLURLAction : NSObject

/** Decoded query key-value pairs are available in URL.queryDictionary. */
@property (nonatomic, readonly) NSURL *URL;

@end

#pragma mark -

typedef void (^BJLURLActionHandleCompletion)(id _Nullable result);
typedef void (^BJLURLActionHandler)(BJLURLAction *action, id _Nullable userInfo, BJLURLActionHandleCompletion _Nullable completion);

typedef void (^BJLURLActionCompletion)(BJLURLAction *action, id _Nullable result);

/**
 *  Config action with URL scheme, host, path and handler.
 *  Handle action and return result by calling completion.
 *  Perform action with URL, userInfo and completion.
 *
 *  The following URL components may be used:
 *      bjlapp    ://  action.hello  :8080  /xxxx  ?  a=1&b=2  #  yyyy
 *      [scheme]  ://  [host]        :port  [path] ?  [query]  #  [fragment]
 *  e.g.
 *      bjlapp://webview.open?url=https%3A%2F%2Fgithub.com%2F
 *  @see NSURL > Structure of a URL
 *
 *  Matching action handlers with URL components combination in order:
 *      [ scheme:// host /path ]
 *      [ scheme:// host /     ]
 *      [ scheme://      /path ]
 *      [ scheme://      /     ]
 *      [           host /path ]
 *      [           host /     ]
 *      [                /path ]
 *      [                /     ]
 */
@interface BJLURLActionManager : NSObject

+ (instancetype)globalActionManager;

/** Case insensitive. */
@property (nonatomic, copy, nullable) NSArray<NSString *> *validSchemes;

/**
 *  Config action with block handler.
 *
 *  @param scheme   case insensitive
 *  @param host     case insensitive
 *  @param path     MUST has prefix /, use / if nil
 *  @param handler  MUST call completion with (id)result or nil when handling action completed
 */
- (void)configWithScheme:(nullable NSString *)scheme host:(nullable NSString *)host path:(nullable NSString *)path handler:(BJLURLActionHandler)handler;
- (void)configWithScheme:(NSString *)scheme handler:(BJLURLActionHandler)handler;
- (void)configWithHost:(nullable NSString *)host path:(nullable NSString *)path handler:(BJLURLActionHandler)handler;

/**
 *  Config action with target[-instance]-action.
 *
 *  @param scheme   case insensitive
 *  @param host     case insensitive
 *  @param path     MUST has prefix /, use / if nil
 *  @param target   class or object
 *  @param instance class method selector to get instance
 *  @param action   class/instance method selector with THREE arguments
 *                  MUST call completion with (id)result or nil when handling action completed
 *                  e.g.
 *                      - (void)yesOrNoWithAction:(BJLURLAction *)action userInfo:(id)userInfo completion:(BJLURLActionHandleCompletion)completion {
 *                          if (completion) completion(@YES);
 *                      }
 */
- (void)configWithScheme:(nullable NSString *)scheme host:(nullable NSString *)host path:(nullable NSString *)path
                  target:(id)target instance:(SEL)instance action:(SEL)action;
- (void)configWithScheme:(NSString *)scheme
                  target:(id)target instance:(SEL)instance action:(SEL)action;
- (void)configWithHost:(nullable NSString *)host path:(nullable NSString *)path
                target:(id)target instance:(SEL)instance action:(SEL)action;

/** Remove action config. */
- (void)removeConfigWithScheme:(nullable NSString *)scheme host:(nullable NSString *)host path:(nullable NSString *)path;

/**
 *  Perform action with URL and user info.
 *
 *  @return performed - URL matched an action handler
 */
- (BOOL)performActionWithURL:(NSURL *)URL userInfo:(nullable id)userInfo completion:(nullable BJLURLActionCompletion)completion;
- (BOOL)performActionWithURLString:(NSString *)URLString completion:(nullable BJLURLActionCompletion)completion;

@end

@interface BJLURLActionManager (BJLURLChainingActions)

/**
 *  Perform chaining action with URL and user info.
 *
 *  Actions are chained via decoded URL-fragment.
 *  Action result returns from action-handler is pass to next action as userInfo.
 *  e.g.
 *      perform(bjlapp://root.goto#bjlapp%3A%2F%2Fvideos.open, userInfo-1)
 *          handle(bjlapp://root.goto, userInfo-1)     >> result-1
 *          decode(bjlapp%3A%2F%2Fvideos.open)         >> bjlapp://videos.open 
 *      perform(bjlapp://videos.open, result-1 as userInfo-2)
 *          handle(bjlapp://videos.open, userInfo-2)   >> result-2
 *          completion(result-2)
 */
- (BOOL)performChainingActionWithURL:(NSURL *)URL userInfo:(nullable id)userInfo completion:(nullable BJLURLActionCompletion)completion;

@end

NS_ASSUME_NONNULL_END
