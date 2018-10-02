//
//  FFRouter.h
//  FFMainProject
//
//  Created by imlifengfeng on 2018/9/18.
//  Copyright © 2018 imlifengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFRouterRewrite.h"
#import "FFRouterNavigation.h"

extern NSString *const FFRouterParameterURLKey;

typedef void (^FFRouterHandler)(NSDictionary *routerParameters);
typedef id (^FFObjectRouterHandler)(NSDictionary *routerParameters);

typedef void (^FFRouterUnregisterURLHandler)(NSString *routerURL);

@interface FFRouter : NSObject


/**
 Register URL

 @param routeURL Registered URL
 @param handlerBlock Callback after routing
 */
+ (void)registerRouteURL:(NSString *)routeURL handler:(FFRouterHandler)handlerBlock;

/**
 Register URL, the URL registered by this way can be returned to Object after Route

 @param routeURL Registered URL
 @param handlerBlock Callback after routing.which can return a Object in callback.
 */
+ (void)registerObjectRouteURL:(NSString *)routeURL handler:(FFObjectRouterHandler)handlerBlock;



/**
 Determine whether URL can be Route (whether it has been registered).

 @param URL URL to be verified
 @return Can it be routed
 */
+ (BOOL)canRouteURL:(NSString *)URL;



/**
 Route a URL

 @param URL URL to be routed
 */
+ (void)routeURL:(NSString *)URL;

/**
 Route a URL and bring additional parameters.

 @param URL URL to be routed
 @param parameters Additional parameters
 */
+ (void)routeURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters;

/**
 Route a URL and get the returned Object

 @param URL URL to be routed
 @return Returned Object
 */
+ (id)routeObjectURL:(NSString *)URL;

/**
 Route a URL and bring additional parameters.get the returned Object

 @param URL URL to be routed
 @param parameters Additional parameters
 @return Returned Object
 */
+ (id)routeObjectURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters;



/**
 Route callback for an unregistered URL

 @param handler Callback
 */
+ (void)routeUnregisterURLHandler:(FFRouterUnregisterURLHandler)handler;



/**
 Cancel registration of a URL

 @param URL URL to be cancelled
 */
+ (void)unregisterRouteURL:(NSString *)URL;

/**
 Unregister all URL
 */
+ (void)unregisterAllRoutes;


/**
 Whether to display Log for debugging

 @param enable YES or NO.The default is NO
 */
+ (void)setLogEnabled:(BOOL)enable;

@end
