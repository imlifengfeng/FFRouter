# FFRouter

[![Version](https://img.shields.io/cocoapods/v/FFRouter.svg?style=flat)](http://cocoapods.org/pods/FFRouter)
[![License](https://img.shields.io/cocoapods/l/FFRouter.svg?style=flat)](http://cocoapods.org/pods/FFRouter)
[![Platform](https://img.shields.io/cocoapods/p/FFRouter.svg?style=flat)](http://cocoapods.org/pods/FFRouter)

### [中文教程](https://github.com/imlifengfeng/FFRouter#中文使用说明)

FFRouter is a powerful and easy-to-use URL routing library in iOS that supports URL Rewrite, allowing the APP to dynamically modify the relevant routing logic after publishing. It is more efficient to find URLs based on matching rather than traversal. Integration and use are very simple!

### function

- [x] Have basic URL registration, Route, cancel registration, print Log, etc.
- [x] Support forward and reverse pass values
- [x] Support the use of wildcards (*) to register URL
- [x] Support URL Rewrite
- [x] Support get the original URL parameter or URLComponents when Rewrite, and can be URL Encode or Decode
- [x] Support get an Object by URL
- [x] Support get an Object by asynchronous callback when Route URL
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
##### 1、Basic Usage
```objective-c
/**
 Register URL,use it with 'routeURL:' and 'routeURL: withParameters:'.
 
 @param routeURL Registered URL
 @param handlerBlock Callback after route
 */
+ (void)registerRouteURL:(NSString *)routeURL handler:(FFRouterHandler)handlerBlock;

/**
 Register URL,use it with 'routeObjectURL:' and ‘routeObjectURL: withParameters:’,can return a Object.
 
 @param routeURL Registered URL
 @param handlerBlock Callback after route, and you can get a Object in this callback.
 */
+ (void)registerObjectRouteURL:(NSString *)routeURL handler:(FFObjectRouterHandler)handlerBlock;

/**
 Registered URL, use it with `routeCallbackURL: targetCallback:'and `routeCallback URL: withParameters: targetCallback:', calls back `targetCallback' asynchronously to return an Object
 
 @param routeURL Registered URL
 @param handlerBlock Callback after route,There is a `targetCallback' in `handlerBlock', which corresponds to the `targetCallback:' in `routeCallbackURL: targetCallback:'and `routeCallbackURL: withParameters: targetCallback:', which can be used for asynchronous callback to return an Object.
 */
+ (void)registerCallbackRouteURL:(NSString *)routeURL handler:(FFCallbackRouterHandler)handlerBlock;




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
 Route a URL and bring additional parameters. get the returned Object
 
 @param URL URL to be routed
 @param parameters Additional parameters
 @return Returned Object
 */
+ (id)routeObjectURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters;

/**
 Route a URL, 'targetCallBack' can asynchronously callback to return a Object.
 
 @param URL URL to be routed
 @param targetCallback asynchronous callback
 */
+ (void)routeCallbackURL:(NSString *)URL targetCallback:(FFRouterCallback)targetCallback;

/**
 Route a URL with additional parameters, and 'targetCallBack' can asynchronously callback to return a Object.
 
 @param URL URL to be routed
 @param parameters Additional parameters
 @param targetCallback asynchronous callback
 */
+ (void)routeCallbackURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters targetCallback:(FFRouterCallback)targetCallback;




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
###### 【Notes】
(1)Register URL
<br>Three types of URL：
```objective-c
[FFRouter registerRouteURL:@"protocol://page/routerDetails/:id" handler:^(NSDictionary *routerParameters) {
   //Callbacks of Route's URL match with this registration URL 
   //routerParameters contains all the parameters that are passed
}];

[FFRouter registerRouteURL:@"wildcard://*" handler:^(NSDictionary *routerParameters) {
   //Callbacks of Route's URL match with this registration URL
   //routerParameters contains all the parameters that are passed  
}];

[FFRouter registerRouteURL:@"protocol://page/routerObjectDetails" handler:^(NSDictionary *routerParameters) {
   //Callbacks of Route's URL match with this registration URL 
   //routerParameters contains all the parameters that are passed
}];
```
The parameters in the URL can be obtained by `routerParameters`，`routerParameters[FFRouterParameterURLKey]`Is the full URL.
<br><br>Three ways of registration and Route：
```objective-c
//Way 1:
+ (void)registerRouteURL:(NSString *)routeURL handler:(FFRouterHandler)handlerBlock;

//Use the following two Route methods
+ (void)routeURL:(NSString *)URL;
+ (void)routeURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters;



//Way 2:
+ (void)registerObjectRouteURL:(NSString *)routeURL handler:(FFObjectRouterHandler)handlerBlock;

//Use the following two Route methods
+ (id)routeObjectURL:(NSString *)URL;
+ (id)routeObjectURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters;



//Way 3:
+ (void)registerCallbackRouteURL:(NSString *)routeURL handler:(FFCallbackRouterHandler)handlerBlock;

//Use the following two Route methods
+ (void)routeCallbackURL:(NSString *)URL targetCallback:(FFRouterCallback)targetCallback;
+ (void)routeCallbackURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters targetCallback:(FFRouterCallback)targetCallback;

```
<br><br><br>(2)When you need to use the following methods：
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
<br><br>(3)If you want to get the returned Object through an asynchronous callback after routeURL, you can register and Route URL using the following method:
```objective-c
//Register URL and return to Object by callback at the necessary time.
[FFRouter registerCallbackRouteURL:@"protocol://page/RouterCallbackDetails" handler:^(NSDictionary *routerParameters, FFRouterCallback targetCallBack) {
       //When necessary, return to Object through'targetCallBack'callback.
       targetCallBack(@"Any Object");
}];

//When Route URL, by 'targetCallback' callbacks to get Object returned
[FFRouter routeCallbackURL:@"protocol://page/RouterCallbackDetails?nickname=imlifengfeng" targetCallback:^(id callbackObjc) {
        self.testLabel.text = [NSString stringWithFormat:@"%@",callbackObjc];
    }];
```
<br><br>(4)If you need to transfer non conventional objects as parameters, such as `UIImage`，You can use the following ways
：
```objective-c
[FFRouter routeURL:@"protocol://page/routerDetails?nickname=imlifengfeng" withParameters:@{@"img":[UIImage imageNamed:@"router_test_img"]}];
```
If you only need to pass common parameters, you can splice parameters directly after URL：
```objective-c
[FFRouter routeURL:@"protocol://page/routerDetails?nickname=imlifengfeng&id=666&parameters......"];
```
Then get these parameters from `routerParameters`. for example：`routerParameters[@"nickname"]`

##### 2、URL Rewrite
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
###### 【Notes】
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
##### 2、FFRouterNavigation
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
- [x] 支持正向、反向传值
- [x] 支持使用通配符(*)注册 URL
- [x] 支持 URL Rewrite
- [x] 支持 Rewrite 时获取原 URL 参数或 URLComponents，并可对其进行URL Encode或 Decode
- [x] 支持通过 URL 获取 Object
- [x] 支持 Route URL 时通过异步回调的方式获取 Object
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
##### 1、基本使用
```objective-c
/**
 注册 url,与 ‘routeURL:’ 和 ‘routeURL: withParameters:’ 配合使用

 @param routeURL 要注册的 URL
 @param handlerBlock URL 被 Route 后的回调
 */
+ (void)registerRouteURL:(NSString *)routeURL handler:(FFRouterHandler)handlerBlock;

/**
 注册 URL,与 'routeObjectURL:' 和 ‘routeObjectURL: withParameters:’ 配合使用,可返回一个 Object

 @param routeURL 要注册的 URL
 @param handlerBlock URL 被 Route 后的回调,可在回调中返回一个 Object
 */
+ (void)registerObjectRouteURL:(NSString *)routeURL handler:(FFObjectRouterHandler)handlerBlock;

/**
 注册 URL,与 ‘routeCallbackURL: targetCallBack:’ 和 ‘routeCallbackURL: withParameters: targetCallBack:’ 配合使用，可异步回调返回一个 Object

 @param routeURL 要注册的 URL
 @param handlerBlock URL 被 Route 后的回调,handlerBlock 中有一个 targetCallBack ,对应 ‘routeCallbackURL: targetCallBack:’ 和 ‘routeCallbackURL: withParameters: targetCallBack:’ 中的 targetCallBack，可用于异步回调返回一个 Object
 */
+ (void)registerCallbackRouteURL:(NSString *)routeURL handler:(FFCallbackRouterHandler)handlerBlock;




/**
 判断 URL 是否可被 Route（是否已经注册）

 @param URL 要判断的 URL
 @return 是否可被 Route
 */
+ (BOOL)canRouteURL:(NSString *)URL;




/**
 Route 一个 URL

 @param URL 要 Route 的 URL
 */
+ (void)routeURL:(NSString *)URL;

/**
 Route 一个 URL，并带上额外参数

 @param URL 要 Route 的 URL
 @param parameters 额外参数
 */
+ (void)routeURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters;

/**
 Route 一个 URL，可获得返回的 Object

 @param URL 要 Route 的 URL
 @return 返回的 Object
 */
+ (id)routeObjectURL:(NSString *)URL;

/**
 Route 一个 URL，并带上额外参数，可获得返回的 Object

 @param URL 要 Route 的 URL
 @param parameters 额外参数
 @return 返回的 Object
 */
+ (id)routeObjectURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters;

/**
 Route 一个 URL,targetCallBack 可异步回调以返回一个 Object

 @param URL 要 Route 的 URL
 @param targetCallback 异步回调
 */
+ (void)routeCallbackURL:(NSString *)URL targetCallback:(FFRouterCallback)targetCallback;

/**
 Route 一个 URL,并带上额外参数,targetCallBack 可异步回调以返回一个 Object

 @param URL 要 Route 的 URL
 @param parameters 额外参数
 @param targetCallback 异步回调
 */
+ (void)routeCallbackURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters targetCallback:(FFRouterCallback)targetCallback;




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
###### 【备注】
(1)注册 URL
<br>三种 URL 类型：
```objective-c
[FFRouter registerRouteURL:@"protocol://page/routerDetails/:id" handler:^(NSDictionary *routerParameters) {
   //Route的URL与本次注册URL匹配时的回调 
   //routerParameters中包含了传递过来的所有参数 
}];

[FFRouter registerRouteURL:@"wildcard://*" handler:^(NSDictionary *routerParameters) {
   //Route的URL与本次注册URL匹配时的回调 
   //routerParameters中包含了传递过来的所有参数 
}];

[FFRouter registerRouteURL:@"protocol://page/routerObjectDetails" handler:^(NSDictionary *routerParameters) {
   //Route的URL与本次注册URL匹配时的回调  
   //routerParameters中包含了传递过来的所有参数
}];
```
可通过`routerParameters`获取 URL 中的参数，`routerParameters[FFRouterParameterURLKey]`为完整的URL.
<br><br>三种注册及 Route 方式：
```objective-c
//注册方式1:
+ (void)registerRouteURL:(NSString *)routeURL handler:(FFRouterHandler)handlerBlock;

//与下面两个 Route 方法配合使用
+ (void)routeURL:(NSString *)URL;
+ (void)routeURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters;



//注册方式2:
+ (void)registerObjectRouteURL:(NSString *)routeURL handler:(FFObjectRouterHandler)handlerBlock;

//与下面两个 Route 方法配合使用，可同步反向传值
+ (id)routeObjectURL:(NSString *)URL;
+ (id)routeObjectURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters;



//注册方式3:
+ (void)registerCallbackRouteURL:(NSString *)routeURL handler:(FFCallbackRouterHandler)handlerBlock;

//与下面两个 Route 方法配合使用，可异步反向传值
+ (void)routeCallbackURL:(NSString *)URL targetCallback:(FFRouterCallback)targetCallback;
+ (void)routeCallbackURL:(NSString *)URL withParameters:(NSDictionary<NSString *, id> *)parameters targetCallback:(FFRouterCallback)targetCallback;

```

<br><br><br>(2)当需要通过以下方法：
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
<br><br>(3)如果想要 routeURL 后通过异步回调获取返回的 Object，可使用下面方法注册和 Route URL：
```objective-c
//注册并在必要时间通过回调返回对应 Object
[FFRouter registerCallbackRouteURL:@"protocol://page/RouterCallbackDetails" handler:^(NSDictionary *routerParameters, FFRouterCallback targetCallBack) {
       //在必要时候通过 targetCallBack 回调去返回对应 Object
       targetCallBack(@"任意Object");
}];

//Route 时通过 ‘targetCallback’ 回调获取返回的对应 Object
[FFRouter routeCallbackURL:@"protocol://page/RouterCallbackDetails?nickname=imlifengfeng" targetCallback:^(id callbackObjc) {
        self.testLabel.text = [NSString stringWithFormat:@"%@",callbackObjc];
    }];
```
<br><br>(4)如果需要传递非常规对象作为参数，如`UIImage`等，可使用如下方式：
```objective-c
[FFRouter routeURL:@"protocol://page/routerDetails?nickname=imlifengfeng" withParameters:@{@"img":[UIImage imageNamed:@"router_test_img"]}];
```
如果只需要传递普通参数，直接在URL后拼接参数即可：
```objective-c
[FFRouter routeURL:@"protocol://page/routerDetails?nickname=imlifengfeng&id=666&parameters......"];
```
之后从`routerParameters`中获取这些参数。例如：`routerParameters[@"nickname"]`

##### 2、URL Rewrite
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
###### 【备注】
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
##### 2、FFRouterNavigation
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