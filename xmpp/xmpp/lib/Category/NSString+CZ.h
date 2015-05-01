
#import <Foundation/Foundation.h>

@interface NSString (CZ)


/**
 *  返回分与秒的字符串 如:01:60
 */
+(NSString *)getMinuteSecondWithSecond:(NSTimeInterval)time;

@end
