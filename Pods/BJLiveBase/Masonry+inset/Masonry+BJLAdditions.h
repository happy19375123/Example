//
//  Masonry+BJLAdditions.h
//  M9Dev
//
//  Created by MingLQ on 2017-04-05.
//  Copyright © 2017 MingLQ <minglq.9@gmail.com>. Released under the MIT license.
//

#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface MASConstraint (BJLAdditions)

- (MASConstraint * (^)(void))bjl_priorityRequired;

@end

#pragma mark -

/**
 @see https://github.com/SnapKit/Masonry/pull/473
 */
@interface MAS_VIEW (BJLAdditions)

@property (nonatomic, readonly, nullable) MASViewAttribute *bjl_safeAreaLayoutGuide;

@property (nonatomic, readonly, nullable) MASViewAttribute *bjl_safeAreaLayoutGuideLeading;
@property (nonatomic, readonly, nullable) MASViewAttribute *bjl_safeAreaLayoutGuideTrailing;
@property (nonatomic, readonly, nullable) MASViewAttribute *bjl_safeAreaLayoutGuideLeft;
@property (nonatomic, readonly, nullable) MASViewAttribute *bjl_safeAreaLayoutGuideRight;
@property (nonatomic, readonly, nullable) MASViewAttribute *bjl_safeAreaLayoutGuideTop;
@property (nonatomic, readonly, nullable) MASViewAttribute *bjl_safeAreaLayoutGuideBottom;
@property (nonatomic, readonly, nullable) MASViewAttribute *bjl_safeAreaLayoutGuideWidth;
@property (nonatomic, readonly, nullable) MASViewAttribute *bjl_safeAreaLayoutGuideHeight;
@property (nonatomic, readonly, nullable) MASViewAttribute *bjl_safeAreaLayoutGuideCenterX;
@property (nonatomic, readonly, nullable) MASViewAttribute *bjl_safeAreaLayoutGuideCenterY;

@end

NS_ASSUME_NONNULL_END
