# FFRouter

[![Version](https://img.shields.io/cocoapods/v/FFAES.svg?style=flat)](http://cocoapods.org/pods/FFRouter)
[![License](https://img.shields.io/cocoapods/l/FFAES.svg?style=flat)](http://cocoapods.org/pods/FFRouter)
[![Platform](https://img.shields.io/cocoapods/p/FFAES.svg?style=flat)](http://cocoapods.org/pods/FFRouter)

### [中文教程](https://github.com/imlifengfeng/FFRouter/blob/master/README.md#中文使用说明)

FFRouter is a powerful and easy-to-use URL routing library in iOS that supports URL Rewrite, allowing the APP to dynamically modify the relevant routing logic after publishing. It is more efficient to find URLs based on matching rather than traversal. Integration and use are very simple!

### function

- [x] Have basic URL registration, Route, cancel registration, print Log, etc.
- [x] Support the use of wildcards (*) to register URL
- [x] Support URL Rewrite
- [x] Support get the original URL parameter or URLComponents when Rewrite, and can be URL Encode or Decode
- [x] Support get an Object by URL
- [x] Support Transferring unconventional objects when Route URL
- [x] Support Route an unregistered URL unified callback


### install
#### CocoaPods

```ruby
target 'MyApp' do
  pod 'FFRouter'
end
```
run `pod install`

#### Manual install

Add the `FFRouter` folder to your project

### Usage
First
```objective-c
#import "FFRouter.h"
```
#####1、Basic Usage
```objective-c
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
```
######【Notes】
(1)Register URL:
```objective-c
[FFRouter registerRouteURL:@"protocol://page/routerDetails/:id" handler:^(NSDictionary *routerParameters) {
   //Callbacks of Route's URL match with this registration URL 
}];

[FFRouter registerRouteURL:@"wildcard://*" handler:^(NSDictionary *routerParameters) {
   //Callbacks of Route's URL match with this registration URL  
}];

[FFRouter registerRouteURL:@"protocol://page/routerObjectDetails" handler:^(NSDictionary *routerParameters) {
   //Callbacks of Route's URL match with this registration URL 
}];
```
The parameters in the URL can be obtained by `routerParameters`，`routerParameters[FFRouterParameterURLKey]`Is the full URL.
<br><br>(2)When you need to use the following methods：
```objective-c
+ (id)routeObjectURL:(NSString *)URL;
```
Route a URL and get the return value, you need to register URL with the following methods：
```objective-c
+ (void)registerObjectRouteURL:(NSString *)routeURL handler:(FFObjectRouterHandler)handlerBlock;
```
And return the corresponding Object in `handlerBlock`, for example：
```objective-c
//Register and return the necessary values
[FFRouter registerObjectRouteURL:@"protocol://page/routerObjectDetails" handler:^id(NSDictionary *routerParameters) {
        NSString *str = @“According to the need to return the necessary Object”;
        return str;
    }];
    
//Gets the returned value
NSString *ret = [FFRouter routeObjectURL:@"protocol://page/routerObjectDetails"];
```

<br><br>(3)If you need to transfer non conventional objects as parameters, such as `UIImage`，You can use the following ways
：
```objective-c
[FFRouter routeURL:@"protocol://page/routerDetails?nickname=imlifengfeng" withParameters:@{@"img":[UIImage imageNamed:@"router_test_img"]}];
```

#####2、URL Rewrite
```objective-c
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
```
######【Notes】
(1)You can add a Rewrite rule using `regular`, for example：
you want to When URL:`https://www.amazon.com/search/Atomic_bomb` is opened, intercept it and use the locally registered URL:`protocol://page/routerDetails?product=Atomic_bomb` to open it.
First, add a Rewrite rule：
```objective-c
[FFRouterRewrite addRewriteMatchRule:@"(?:https://)?www.amazon.com/search/(.*)" targetRule:@"protocol://page/routerDetails?product=$1"];
```
After open URL:`https://www.amazon.com/search/Atomic_bomb`，Will Rewrite into URL:`protocol://page/routerDetails?product=Atomic_bomb`。
```objective-c
[FFRouter routeURL:@"https://www.amazon.com/search/Atomic_bomb"];
```
<br><br>(2)You can add multiple rules using the following methods：
```objective-c
+ (void)addRewriteRules:(NSArray<NSDictionary *> *)rules;
```
The rules format must be in the following format：
```objective-c
@[@{@"matchRule":@"YourMatchRule1",@"targetRule":@"YourTargetRule1"},
  @{@"matchRule":@"YourMatchRule2",@"targetRule":@"YourTargetRule2"},
  @{@"matchRule":@"YourMatchRule3",@"targetRule":@"YourTargetRule3"},]
```
<br><br>(3)Reserved words in Rewrite rules：
- Get the corresponding part of the standard URL via `$scheme`, `$host`, `$port`, `$path`, `$query`, `$fragment`. Get the full URL via `$url`
- Use `$1`, `$2`, `$3`... to get the parameters of the `matchRule` rule using parentheses
- `$`: the value of the original variable, `$$`: the value of the original variable URL Encode, `$#`: the value of the original variable URL Decode

<br>for example：
`https://www.taobao.com/search/原子弹`for the Rewrite rule`(?:https://)?www.taobao.com/search/(.*)`

```objective-c
$1=原子弹
$$1=%e5%8e%9f%e5%ad%90%e5%bc%b9
```
the same as，`https://www.taobao.com/search/%e5%8e%9f%e5%ad%90%e5%bc%b9`for the Rewrite rule`(?:https://)?www.taobao.com/search/(.*)`

```objective-c
$1=%e5%8e%9f%e5%ad%90%e5%bc%b9
$#1=原子弹
```
#####2、FFRouterNavigation
Considering the frequent use of routing to configure the jump between `UIViewController`, an additional tool `FFRouterNavigation` has been added to make it easier to control jumps between `UIViewController`. Use as follows:
```objective-c
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
```
## License
This project is used under the <a href="http://opensource.org/licenses/MIT" target="_blank">MIT</a> license agreement. For more information, see <a href="https://github.com/imlifengfeng/FFRouter/blob/master/LICENSE">LICENSE</a>.















# 中文使用说明
FFRouter 是 iOS 中一个强大且易用的 URL 路由库，支持 URL Rewrite，使 APP 在发布之后也可以动态修改相关路由逻辑。基于匹配查找 URL，效率高。集成和使用都非常简单！
### 功能

- [x] 具备基本的 URL 注册、Route、取消注册、打印 Log 等
- [x] 支持使用通配符(*)注册 URL
- [x] 支持 URL Rewrite
- [x] 支持 Rewrite 时获取原 URL 参数或 URLComponents，并可对其进行URL Encode或 Decode
- [x] 支持通过 URL 获取 Object
- [x] 支持 Route URL 时传递非常规对象
- [x] 支持 Route 一个未注册的 URL 时统一回调


### 安装
#### CocoaPods

```ruby
target 'MyApp' do
  pod 'FFRouter'
end
```
运行 `pod install`

#### 手动安装

添加其中的 `FFRouter` 文件夹到自己项目

### 使用方法
首先
```objective-c
#import "FFRouter.h"
```
#####1、基本使用
```objective-c
/**
 注册 url

 @param routeURL 要注册的 URL
 @param handlerBlock URL 被 Route 后的回调
 */
+ (void)registerRouteURL:(NSString *)routeURL handler:(FFRouterHandler)handlerBlock;

/**
 注册 URL,通过该方式注册的 URL 被 Route 后可返回一个 Object

 @param routeURL 要注册的 URL
 @param handlerBlock URL 被 Route 后的回调,可在回调中返回一个 Object
 */
+ (void)registerObjectRouteURL:(NSString *)routeURL handler:(FFObjectRouterHandler)handlerBlock;



/**
 判断 URL 是否可被 Route（是否已经注册）

 @param URL 要判断的 URL
 @return 是否可被 Route
 */
+ (BOOL)canRouteURL:(NSString *)URL;



/**
 Route 一个 URL

 @param URL 要 Router 的 URL
 */
+ (void)routeURL:(NSString *)URL;

/**
 Route 一个 URL，并带上额外参数

 @param URL 要 Router 的 URL
 @param parameters 额外参数
 */
+ (void)routeURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters;

/**
 Route 一个 URL，可获得返回的 Object

 @param URL 要 Router 的 URL
 @return 返回的 Object
 */
+ (id)routeObjectURL:(NSString *)URL;

/**
 Route 一个 URL，并带上额外参数，可获得返回的 Object

 @param URL 要 Router 的 URL
 @param parameters 额外参数
 @return 返回的 Object
 */
+ (id)routeObjectURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters;



/**
 Route 一个未注册 URL 时回调

 @param handler 回调
 */
+ (void)routeUnregisterURLHandler:(FFRouterUnregisterURLHandler)handler;



/**
 取消注册某个 URL

 @param URL 要被取消注册的 URL
 */
+ (void)unregisterRouteURL:(NSString *)URL;

/**
 取消注册所有 URL
 */
+ (void)unregisterAllRoutes;


/**
 是否显示 Log，用于调试

 @param enable YES or NO，默认为 NO
 */
+ (void)setLogEnabled:(BOOL)enable;
```
######【备注】
(1)注册 URL:
```objective-c
[FFRouter registerRouteURL:@"protocol://page/routerDetails/:id" handler:^(NSDictionary *routerParameters) {
   //Route的URL与本次注册URL匹配时的回调  
}];

[FFRouter registerRouteURL:@"wildcard://*" handler:^(NSDictionary *routerParameters) {
   //Route的URL与本次注册URL匹配时的回调  
}];

[FFRouter registerRouteURL:@"protocol://page/routerObjectDetails" handler:^(NSDictionary *routerParameters) {
   //Route的URL与本次注册URL匹配时的回调  
}];
```
可通过`routerParameters`获取 URL 中的参数，`routerParameters[FFRouterParameterURLKey]`为完整的URL.
<br><br>(2)当需要通过以下方法：
```objective-c
+ (id)routeObjectURL:(NSString *)URL;
```
Route 一个 URL 并获取返回值时，需要使用如下方法注册 URL：
```objective-c
+ (void)registerObjectRouteURL:(NSString *)routeURL handler:(FFObjectRouterHandler)handlerBlock;
```
并在 handlerBlock 中返回需要返回的 Object，例如：
```objective-c
//注册并返回必要的值
[FFRouter registerObjectRouteURL:@"protocol://page/routerObjectDetails" handler:^id(NSDictionary *routerParameters) {
        NSString *str = @“根据需要返回必要的Object”;
        return str;
    }];
    
//获取返回的值
NSString *ret = [FFRouter routeObjectURL:@"protocol://page/routerObjectDetails"];
```

<br><br>(3)如果需要传递非常规对象作为参数，如`UIImage`等，可使用如下方式：
```objective-c
[FFRouter routeURL:@"protocol://page/routerDetails?nickname=imlifengfeng" withParameters:@{@"img":[UIImage imageNamed:@"router_test_img"]}];
```

#####2、URL Rewrite
```objective-c
/**
 根据设置的 Rules 去 rewrite 一个 URL

 @param url 将被 rewrite 的 URL
 @return rewrite 后的 URL
 */
+ (NSString *)rewriteURL:(NSString *)url;

/**
 添加一个 RewriteRule

 @param matchRule 正则匹配规则
 @param targetRule 转换规则
 */
+ (void)addRewriteMatchRule:(NSString *)matchRule targetRule:(NSString *)targetRule;

/**
 同时添加多个 RewriteRule，格式必须为：@[@{@"matchRule":@"YourMatchRule",@"targetRule":@"YourTargetRule"},...]

 @param rules RewriteRules
 */
+ (void)addRewriteRules:(NSArray<NSDictionary *> *)rules;

/**
 移除一个 RewriteRule

 @param matchRule 将被移除的 matchRule
 */
+ (void)removeRewriteMatchRule:(NSString *)matchRule;

/**
 移除所有 RewriteRule
 */
+ (void)removeAllRewriteRules;
```
######【备注】
(1)可以使用`正则`添加一条 Rewrite 规则，例如：
要实现打开 URL:`https://www.taobao.com/search/原子弹`时，将其拦截，改用本地已注册的 URL:`protocol://page/routerDetails?product=原子弹`打开。
首先添加一条 Rewrite 规则：
```objective-c
[FFRouterRewrite addRewriteMatchRule:@"(?:https://)?www.taobao.com/search/(.*)" targetRule:@"protocol://page/routerDetails?product=$1"];
```
之后在打开URL:`https://www.taobao.com/search/原子弹`时，将会 Rewrite 到URL:`protocol://page/routerDetails?product=原子弹`。
```objective-c
[FFRouter routeURL:@"https://www.taobao.com/search/原子弹"];
```
<br><br>(2)可以通过以下方法同时增加多个规则：
```objective-c
+ (void)addRewriteRules:(NSArray<NSDictionary *> *)rules;
```
其中 rules 格式必须为以下格式：
```objective-c
@[@{@"matchRule":@"YourMatchRule1",@"targetRule":@"YourTargetRule1"},
  @{@"matchRule":@"YourMatchRule2",@"targetRule":@"YourTargetRule2"},
  @{@"matchRule":@"YourMatchRule3",@"targetRule":@"YourTargetRule3"},]
```
<br><br>(3)Rewrite 规则中的保留字：
- 通过 `$scheme`、`$host`、`$port`、`$path`、`$query`、`$fragment` 获取标准 URL 中的相应部分。通过`$url`获取完整 URL
- 通过 `$1`、`$2`、`$3`...获取`matchRule`的正则中使用圆括号取出的参数
- `$`：原变量的值、`$$`：原变量URL Encode后的值、`$#`：原变量URL Decode后的值

<br>例如：
`https://www.taobao.com/search/原子弹`对于Rewrite 规则`(?:https://)?www.taobao.com/search/(.*)`

```objective-c
$1=原子弹
$$1=%e5%8e%9f%e5%ad%90%e5%bc%b9
```
同样，`https://www.taobao.com/search/%e5%8e%9f%e5%ad%90%e5%bc%b9`对于Rewrite 规则`(?:https://)?www.taobao.com/search/(.*)`

```objective-c
$1=%e5%8e%9f%e5%ad%90%e5%bc%b9
$#1=原子弹
```
#####2、FFRouterNavigation
考虑到经常用路由配置`UIViewController`之间的跳转，所以增加了额外的工具`FFRouterNavigation`来更方便地控制`UIViewController`之间的跳转。具体使用方法如下：
```objective-c
/**
 push 时是否自动隐藏底部TabBar

 @param hide 是否自动隐藏，默认为 NO
 */
+ (void)autoHidesBottomBarWhenPushed:(BOOL)hide;



/**
 获取当前 ViewController

 @return 当前 ViewController
 */
+ (UIViewController *)currentViewController;

/**
 获取当前 NavigationViewController

 @return return 当前 NavigationViewController
 */
+ (nullable UINavigationController *)currentNavigationViewController;



/**
 Push ViewController

 @param viewController 被 Push 的 ViewController
 @param animated 是否使用动画
 */
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 Push ViewController，可设置当前 ViewController 是否还保留

 @param viewController 被 Push 的 ViewController
 @param replace 当前 ViewController 是否还保留
 @param animated 是否使用动画
 */
+ (void)pushViewController:(UIViewController *)viewController replace:(BOOL)replace animated:(BOOL)animated;

/**
 Push 多个 ViewController

 @param viewControllers ViewController Array
 @param animated 是否使用动画
 */
+ (void)pushViewControllerArray:(NSArray *)viewControllers animated:(BOOL)animated;

/**
 present ViewController

 @param viewController 被 present 的 ViewController
 @param animated 是否使用动画
 @param completion 回调
 */
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;



/**
 关闭当前 ViewController，push、present 方式通用

 @param animated 是否使用动画
 */
+ (void)closeViewControllerAnimated:(BOOL)animated;
```
### 感谢
`FFRouter`实现方案参考了以下文章，在此表示感谢！
- [天猫解耦神器 —— 统跳协议和Rewrite引擎](http://pingguohe.net/2015/11/24/Navigator-and-Rewrite.html)
- [蘑菇街 App 的组件化之路](http://limboy.me/tech/2016/03/10/mgj-components.html)

## 许可

该项目在 <a href="http://opensource.org/licenses/MIT" target="_blank">MIT</a> 许可协议下使用.  有关详细信息，请参阅 <a href="https://github.com/imlifengfeng/FFRouter/blob/master/LICENSE">LICENSE</a>.