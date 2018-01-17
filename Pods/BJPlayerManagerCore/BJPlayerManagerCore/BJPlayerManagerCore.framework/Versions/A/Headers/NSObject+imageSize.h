//
//  NSObject+imageSize.h
//  BJPlayerManagerCore
//
//  Created by 辛亚鹏 on 2017/9/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (imageSize)

/**
 由url获取图片的尺寸
 
 @param imageURL url, 兼容NSString和NSURL
 @return size
 */
- (CGSize)getImageSizeWithURL:(id)imageURL;

@end

NS_ASSUME_NONNULL_END
