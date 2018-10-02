//
//  AppDelegate.m
//  FFRouterDemo
//
//  Created by imlifengfeng on 2018/10/1.
//  Copyright © 2018年 imlifengfeng. All rights reserved.
//

#import "AppDelegate.h"
#import "RouterDemoController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[RouterDemoController new]];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
