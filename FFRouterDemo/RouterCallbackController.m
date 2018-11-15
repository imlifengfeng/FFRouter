//
//  RouterCallbackController.m
//  FFRouterDemo
//
//  Created by imlifengfeng on 2018/11/15.
//  Copyright © 2018 imlifengfeng. All rights reserved.
//

#import "RouterCallbackController.h"

@interface RouterCallbackController ()

@property (nonatomic,strong) TestCallback callback;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation RouterCallbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoLabel.text = self.infoStr;
}

-(void)testCallBack:(TestCallback)callback {
    self.callback = callback;
}

- (IBAction)callbackBtnClick:(id)sender {
    if (self.callback) {
        NSString *callbackStr = [NSString stringWithFormat:@"我是回调过来的字符串 %@",[self getCurrentTime]];
        self.callback(callbackStr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:dateNow];
    return currentTimeString;
}

@end
