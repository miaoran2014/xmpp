

#import <UIKit/UIKit.h>

@interface UIImage (CZ)




/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;


+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (instancetype)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  根据宽度进行比例压缩返回小图片
 *
 *  @param path  文件路径
 *  @param width 指定图片宽
 */
-(UIImage *)scaleImageWithWidth:(CGFloat)width;
@end
