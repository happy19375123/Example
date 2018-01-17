// The MIT License (MIT)
//
// Copyright (c) 2014 Suyeol Jeon (http:xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <objc/runtime.h>
#import <BJLiveBase/NSObject+BJLObserving.h>

#import "UITextView+BJLPlaceholder.h"

@implementation UITextView (BJLPlaceholder)

#pragma mark - Class Methods
#pragma mark `defaultPlaceholderColor`

+ (UIColor *)bjl_defaultPlaceholderColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        color = [textField valueForKeyPath:@"_placeholderLabel.textColor"];
    });
    return color;
}


#pragma mark - `observingKeys`

+ (NSArray *)bjl_observingKeys {
    return @[@"attributedText",
             @"bounds",
             @"font",
             @"frame",
             @"text",
             @"textAlignment",
             @"textContainerInset"];
}


#pragma mark - Properties
#pragma mark `placeholderLabel`

- (UILabel *)bjl_placeholderLabel {
    UILabel *label = objc_getAssociatedObject(self, @selector(bjl_placeholderLabel));
    if (!label) {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" "; // lazily set font of `UITextView`.
        self.attributedText = originalText;

        label = [[UILabel alloc] init];
        label.textColor = [self.class bjl_defaultPlaceholderColor];
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, @selector(bjl_placeholderLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        self.bjl_needsUpdateFont = YES;
        [self bjl_updatePlaceholderLabel];
        self.bjl_needsUpdateFont = NO;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bjl_updatePlaceholderLabel)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];

        for (NSString *key in self.class.bjl_observingKeys) {
            [self bjl_kvo:[BJLPropertyMeta instanceWithTarget:self name:key]
                  options:NSKeyValueObservingOptionNew
                 observer:^BOOL(id _Nullable old, id _Nullable now) {
                     if ([key isEqualToString:@"font"]) {
                         self.bjl_needsUpdateFont = (now != nil);
                     }
                     [self bjl_updatePlaceholderLabel];
                     return YES;
                 }];
        }
    }
    return label;
}


#pragma mark `placeholder`

- (NSString *)bjl_placeholder {
    return self.bjl_placeholderLabel.text;
}

- (void)setBjl_placeholder:(NSString *)placeholder {
    self.bjl_placeholderLabel.text = placeholder;
    [self bjl_updatePlaceholderLabel];
}

- (NSAttributedString *)bjl_attributedPlaceholder {
    return self.bjl_placeholderLabel.attributedText;
}

- (void)setBjl_attributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.bjl_placeholderLabel.attributedText = attributedPlaceholder;
    [self bjl_updatePlaceholderLabel];
}

#pragma mark `placeholderColor`

- (UIColor *)bjl_placeholderColor {
    return self.bjl_placeholderLabel.textColor;
}

- (void)setBjl_placeholderColor:(UIColor *)placeholderColor {
    self.bjl_placeholderLabel.textColor = placeholderColor;
}


#pragma mark `needsUpdateFont`

- (BOOL)bjl_needsUpdateFont {
    return [objc_getAssociatedObject(self, @selector(bjl_needsUpdateFont)) boolValue];
}

- (void)setBjl_needsUpdateFont:(BOOL)needsUpdate {
    objc_setAssociatedObject(self, @selector(bjl_needsUpdateFont), @(needsUpdate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Update

- (void)bjl_updatePlaceholderLabel {
    if (self.text.length) {
        [self.bjl_placeholderLabel removeFromSuperview];
        return;
    }

    [self insertSubview:self.bjl_placeholderLabel atIndex:0];

    if (self.bjl_needsUpdateFont) {
        self.bjl_placeholderLabel.font = self.font;
        self.bjl_needsUpdateFont = NO;
    }
    self.bjl_placeholderLabel.textAlignment = self.textAlignment;

    // `NSTextContainer` is available since iOS 7
    CGFloat lineFragmentPadding;
    UIEdgeInsets textContainerInset;

#pragma deploymate push "ignored-api-availability"
    // iOS 7+
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        lineFragmentPadding = self.textContainer.lineFragmentPadding;
        textContainerInset = self.textContainerInset;
    }
#pragma deploymate pop

    // iOS 6
    else {
        lineFragmentPadding = 5;
        textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    }

    CGFloat x = lineFragmentPadding + textContainerInset.left;
    CGFloat y = textContainerInset.top;
    CGFloat width = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
    CGFloat height = [self.bjl_placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
    self.bjl_placeholderLabel.frame = CGRectMake(x, y, width, height);
}

@end
