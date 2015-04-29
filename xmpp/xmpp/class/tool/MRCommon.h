
#import <Foundation/Foundation.h>

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"

//调试模式下才有需要日志输入功能
#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif


#define HMLogWarn(...) DDLogWarn(@"%s %d \n %@\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#define HMLogError(...) DDLogError(@"%s %d \n %@\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#define HMLogInfo(...) DDLogInfo(@"%s %d \n %@\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#define HMLogVerbose(...) DDLogVerbose(@"%s %d \n %@\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

@interface MRCommon : NSObject

@end
