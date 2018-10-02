//
//  FFRouterNavigation.h
//  FFMainProject
//
//  Created by imlifengfeng on 2018/9/21.
//  Copyright © 2018 imlifengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FFRouterNavigation : NSObject

/**
 Whether TabBar automatically hide when push

 @param hide Whether to automatically hide, the default is NO
 */
+ (void)autoHidesBottomBarWhenPushed:(BOOL)hide;



/**
 Get current ViewController

 @return Current ViewController
 */
+ (UIViewController *)currentViewController;

/**
 Get current NavigationViewController

 @return return Current NavigationViewController
 */
+ (nullable UINavigationController *)currentNavigationViewController;



/**
 Push ViewController

 @param viewController Target ViewController
 @param animated Whether to use animation
 */
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 Push ViewController，can set whether the current ViewController is still reserved.

 @param viewController Target ViewController
 @param replace whether the current ViewController is still reserved
 @param animated Whether to use animation
 */
+ (void)pushViewController:(UIViewController *)viewController replace:(BOOL)replace animated:(BOOL)animated;

/**
 Push multiple ViewController

 @param viewControllers ViewController Array
 @param animated Whether to use animation
 */
+ (void)pushViewControllerArray:(NSArray *)viewControllers animated:(BOOL)animated;

/**
 present ViewController

 @param viewController Target ViewController
 @param animated Whether to use animation
 @param completion Callback
 */
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;



/**
 Close the current ViewController, push, present universal

 @param animated Whether to use animation
 */
+ (void)closeViewControllerAnimated:(BOOL)animated;

@end

