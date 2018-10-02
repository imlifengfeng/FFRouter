//
//  FFRouterRewrite.h
//  FFMainProject
//
//  Created by imlifengfeng on 2018/9/24.
//  Copyright © 2018年 imlifengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFRouterRewrite : NSObject

/**
 According to the set of Rules, go to rewrite URL.

 @param url URL to be rewritten
 @return URL after being rewritten
 */
+ (NSString *)rewriteURL:(NSString *)url;

/**
 Add a RewriteRule

 @param matchRule Regular matching rule
 @param targetRule Conversion rules
 */
+ (void)addRewriteMatchRule:(NSString *)matchRule targetRule:(NSString *)targetRule;

/**
 Add multiple RewriteRule at the same time, the format must be：@[@{@"matchRule":@"YourMatchRule",@"targetRule":@"YourTargetRule"},...]

 @param rules RewriteRules
 */
+ (void)addRewriteRules:(NSArray<NSDictionary *> *)rules;

/**
 Remove a RewriteRule

 @param matchRule MatchRule to be removed
 */
+ (void)removeRewriteMatchRule:(NSString *)matchRule;

/**
 Remove all RewriteRule
 */
+ (void)removeAllRewriteRules;

@end
