//
//  RouterDemoController.m
//  FFRouterDemo
//
//  Created by imlifengfeng on 2018/10/1.
//  Copyright © 2018年 imlifengfeng. All rights reserved.
//

#import "RouterDemoController.h"
#import "FFRouter.h"
#import "RouterDetailController.h"
#import "RouterCallbackController.h"

@interface RouterDemoController ()

@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation RouterDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"FFRouterDemo";
    
    [self registerRouteURL];
    [self addRewriteMatchRules];
}

- (void)registerRouteURL {
    [FFRouter setLogEnabled:YES];
    
    //注册 protocol://page/routerDetails
    [FFRouter registerRouteURL:@"protocol://page/routerDetails" handler:^(NSDictionary *routerParameters) {
        RouterDetailController *mRouterDetailController = [[RouterDetailController alloc]init];
        [FFRouterNavigation pushViewController:mRouterDetailController animated:YES];
        
        [mRouterDetailController addLogText:@"match ——> protocol://page/routerDetails"];
        [mRouterDetailController addLogText:[NSString stringWithFormat:@"%@",routerParameters]];
        
        if ([routerParameters objectForKey:@"img"]) {
            UIImage *img = [routerParameters objectForKey:@"img"];
            [mRouterDetailController setLogImage:img];
        }
    }];
    
    //注册 protocol://page/routerObjectDetails
    [FFRouter registerObjectRouteURL:@"protocol://page/routerObjectDetails" handler:^id(NSDictionary *routerParameters) {
        RouterDetailController *mRouterDetailController = [[RouterDetailController alloc]init];
        NSString *str = [NSString stringWithFormat:@"%@",[mRouterDetailController testDetailObjectResult]];
        return str;
    }];
    
    //注册 protocol://page/RouterCallbackDetails
    [FFRouter registerCallbackRouteURL:@"protocol://page/RouterCallbackDetails" handler:^(NSDictionary *routerParameters, FFRouterCallback targetCallback) {
        RouterCallbackController *callbackVC = [[RouterCallbackController alloc]init];
        callbackVC.infoStr = [NSString stringWithFormat:@"%@",routerParameters];
        [callbackVC testCallBack:^(NSString *callbackStr) {
            targetCallback(callbackStr);
        }];
        [FFRouterNavigation pushViewController:callbackVC animated:YES];
    }];
    
     //注册 wildcard://*
    [FFRouter registerRouteURL:@"wildcard://*" handler:^(NSDictionary *routerParameters) {
        RouterDetailController *mRouterDetailController = [[RouterDetailController alloc]init];
        [FFRouterNavigation pushViewController:mRouterDetailController animated:YES];
        
        [mRouterDetailController addLogText:@"match ——> wildcard://*"];
        [mRouterDetailController addLogText:[NSString stringWithFormat:@"%@",routerParameters]];

    }];
    
    //route一个未注册URL回调
    [FFRouter routeUnregisterURLHandler:^(NSString *routerUrl) {
        NSLog(@"未注册的URL：\n%@",routerUrl);
    }];
}

- (void)addRewriteMatchRules {
    [FFRouterRewrite addRewriteMatchRule:@"(?:https://)?www.baidu.com/wd/(\\d+)" targetRule:@"protocol://page/routerDetails?id=$1"];
    [FFRouterRewrite addRewriteMatchRule:@"(?:https://)?www.taobao.com/search/(.*)" targetRule:@"protocol://page/routerDetails?id=$$1"];
    [FFRouterRewrite addRewriteMatchRule:@"(?:https://)?www.jd.com/search/(.*)" targetRule:@"protocol://page/routerDetails?id=$#1"];
}

//routeURL
- (IBAction)btn1Click:(id)sender {
    [FFRouter routeURL:@"protocol://page/routerDetails?nickname=imlifengfeng&nation=中国"];
}

//routeURL并传递对象参数
- (IBAction)btn2Click:(id)sender {
    [FFRouter routeURL:@"protocol://page/routerDetails?nickname=imlifengfeng&nation=中国" withParameters:@{@"img":[UIImage imageNamed:@"router_test_img"]}];
}

//通过routeObjectURL获取返回值
- (IBAction)btn3Click:(id)sender {
    NSString *ret = [FFRouter routeObjectURL:@"protocol://page/routerObjectDetails"];
    self.testLabel.text = ret;
}

//通过routeCallbackURL异步回调获取返回值
- (IBAction)btn4Click:(id)sender {
    [FFRouter routeCallbackURL:@"protocol://page/RouterCallbackDetails?nickname=imlifengfeng&nation=中国" targetCallback:^(id callbackObjc) {
        self.testLabel.text = [NSString stringWithFormat:@"%@",callbackObjc];
    }];
}

//通配符(*)方式注册URL
- (IBAction)btn5Click:(id)sender {
    [FFRouter routeURL:@"wildcard://path/path2/path3?nickname=imlifengfeng&nation=中国"];
}

//route一个未注册的URL
- (IBAction)btn6Click:(id)sender {
    [FFRouter routeURL:@"protocol://hahahhahahhahhaha"];
}

//Rewrite一个URL
- (IBAction)btn7Click:(id)sender {
     [FFRouter routeURL:@"https://www.baidu.com/wd/66666"];
}

//Rewrite一个URL并对某值URL Encode
- (IBAction)btn8Click:(id)sender {
    [FFRouter routeURL:@"https://www.taobao.com/search/原子弹"];
}

//Rewrite一个URL并对某值URL Decode
- (IBAction)btn9Click:(id)sender {
    [FFRouter routeURL:@"https://www.jd.com/search/%E5%8E%9F%E5%AD%90%E5%BC%B9"];
}

@end
