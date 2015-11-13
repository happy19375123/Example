//
//  SSCalendarCollectionViewFlowLayout.m
//  Example
//
//  Created by 张鹏 on 15/11/12.
//  Copyright © 2015年 张鹏. All rights reserved.
//

#import "SSCalendarCollectionViewFlowLayout.h"

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

@implementation SSCalendarCollectionViewFlowLayout

-(id)init{
    self = [super init];
    if(self){
        self.minimumInteritemSpacing = 0.0;
        self.minimumLineSpacing = 0.0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}


//当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds{
    return YES;
}

//对齐到网格
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
    
    //计算出实际中心位置
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.y + (CGRectGetHeight(self.collectionView.bounds) / 2.0);
    
    //取当前屏幕中的UICollectionViewLayoutAttributes
    CGRect targetRect = CGRectMake(0.0, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.y;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    
    //返回调整好的point
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + offsetAdjustment);
}

@end
