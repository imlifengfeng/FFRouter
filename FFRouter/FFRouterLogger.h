//
//  FFRouterLogger.h
//  FFMainProject
//
//  Created by imlifengfeng on 2018/9/21.
//  Copyright © 2018 imlifengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FFRouterLogLevel(lvl,fmt,...)\
[FFRouterLogger log : YES                                      \
level : lvl                                                  \
file : __FILE__                                            \
function : __PRETTY_FUNCTION__                       \
line : __LINE__                                           \
format : (fmt), ## __VA_ARGS__]

#define FFRouterLog(fmt,...)\
FFRouterLogLevel(FFRouterLoggerLevelInfo,(fmt), ## __VA_ARGS__)

#define FFRouterWarningLog(fmt,...)\
FFRouterLogLevel(FFRouterLoggerLevelWarning,(fmt), ## __VA_ARGS__)

#define FFRouterErrorLog(fmt,...)\
FFRouterLogLevel(FFRouterLoggerLevelError,(fmt), ## __VA_ARGS__)


typedef NS_ENUM(NSUInteger,FFRouterLoggerLevel){
    FFRouterLoggerLevelInfo = 1,
    FFRouterLoggerLevelWarning ,
    FFRouterLoggerLevelError ,
};

@interface FFRouterLogger : NSObject

@property(class , readonly, strong) FFRouterLogger *sharedInstance;

+ (BOOL)isLoggerEnabled;

+ (void)enableLog:(BOOL)enableLog;

+ (void)log:(BOOL)asynchronous
      level:(NSInteger)level
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
     format:(NSString *)format, ... ;

@end
