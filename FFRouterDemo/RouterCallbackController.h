//
//  RouterCallbackController.h
//  FFRouterDemo
//
//  Created by imlifengfeng on 2018/11/15.
//  Copyright © 2018 imlifengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TestCallback)(NSString *callbackStr);

@interface RouterCallbackController : UIViewController

-(void)testCallBack:(TestCallback)callback;

@property (nonatomic,strong) NSString *infoStr;

@end
