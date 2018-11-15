//
//  FFRouterLogger.m
//  FFMainProject
//
//  Created by imlifengfeng on 2018/9/21.
//  Copyright © 2018 imlifengfeng. All rights reserved.
//

#import "FFRouterLogger.h"
#import <Foundation/Foundation.h>

static BOOL __enableLog__ ;
static dispatch_queue_t __logQueue__ ;

@implementation FFRouterLogger

+ (void)initialize {
    __enableLog__ = NO;
    __logQueue__ = dispatch_queue_create("com.ffrouter.log", DISPATCH_QUEUE_SERIAL);
}

+ (BOOL)isLoggerEnabled {
    __block BOOL enable = NO;
    dispatch_sync(__logQueue__, ^{
        enable = __enableLog__;
    });
    return enable;
}

+ (void)enableLog:(BOOL)enableLog {
    dispatch_sync(__logQueue__, ^{
        __enableLog__ = enableLog;
    });
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)log:(BOOL)asynchronous
      level:(NSInteger)level
     format:(NSString *)format, ... {
    @try{
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self.sharedInstance log:asynchronous message:message level:level];
        va_end(args);
    } @catch(NSException *e){
        
    }
}

- (void)log:(BOOL)asynchronous
    message:(NSString *)message
      level:(NSInteger)level {
    @try{
        NSString *logMessage = [[NSString alloc]initWithFormat:@"[FFRouterLog][%@] %@",[self descriptionForLevel:level],message];
        if (__enableLog__) {
            NSLog(@"%@",logMessage);
        }
    } @catch(NSException *e){
        
    }
}

-(NSString *)descriptionForLevel:(FFRouterLoggerLevel)level {
    NSString *desc = nil;
    switch (level) {
        case FFRouterLoggerLevelInfo:
            desc = @"INFO";
            break;
        case FFRouterLoggerLevelWarning:
            desc = @"⚠️ WARN";
            break;
        case FFRouterLoggerLevelError:
            desc = @"❌ ERROR";
            break;
        default:
            desc = @"UNKNOW";
            break;
    }
    return desc;
}

@end
