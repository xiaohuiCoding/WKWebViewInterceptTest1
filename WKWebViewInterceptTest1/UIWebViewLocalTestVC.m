//
//  UIWebViewLocalTestVC.m
//  WKWebViewInterceptTest1
//
//  Created by xiaohui on 2018/3/14.
//  Copyright © 2018年 XIAOHUI. All rights reserved.
//

#import "UIWebViewLocalTestVC.h"
#import <AVFoundation/AVFoundation.h>

@interface UIWebViewLocalTestVC () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation UIWebViewLocalTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
    NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    //    NSURL *htmlURL = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlURL];
    // UIWebView 滚动的比较慢，这里设置为正常速度
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

#pragma mark - private method

- (void)handleCustomAction:(NSURL *)URL {
    NSString *host = [URL host];
    if ([host isEqualToString:@"scanClick"]) {
        NSLog(@"扫一扫");
    } else if ([host isEqualToString:@"shareClick"]) {
        [self share:URL];
    } else if ([host isEqualToString:@"getLocation"]) {
        [self getLocation];
    } else if ([host isEqualToString:@"setColor"]) {
        [self changeBGColor:URL];
    } else if ([host isEqualToString:@"payAction"]) {
        [self payAction:URL];
    } else if ([host isEqualToString:@"shake"]) {
        [self shakeAction];
    } else if ([host isEqualToString:@"back"]) {
        [self goBack];
    }
}

- (void)getLocation {
    // 将获取到的位置信息返回给js
    NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",@"您当前的位置是浙江省杭州市"];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
}

- (void)share:(NSURL *)URL {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSArray *params =[URL.query componentsSeparatedByString:@"&"];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByRemovingPercentEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    NSString *title = [tempDic objectForKey:@"title"];
    NSString *content = [tempDic objectForKey:@"content"];
    NSString *url = [tempDic objectForKey:@"url"];
    // 将要分享的信息返回给js
    NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
}

- (void)changeBGColor:(NSURL *)URL {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSArray *params =[URL.query componentsSeparatedByString:@"&"];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByRemovingPercentEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    CGFloat r = [[tempDic objectForKey:@"r"] floatValue];
    CGFloat g = [[tempDic objectForKey:@"g"] floatValue];
    CGFloat b = [[tempDic objectForKey:@"b"] floatValue];
    CGFloat a = [[tempDic objectForKey:@"a"] floatValue];
    self.view.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

- (void)payAction:(NSURL *)URL {
    
    //    NSString *jsStr = [NSString stringWithFormat:@"payResult('%@')",@"支付成功"];
    //    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    //        NSLog(@"pay:%@----%@",result, error);
    //    }];
    
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSArray *params =[URL.query componentsSeparatedByString:@"&"];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByRemovingPercentEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    NSString *orderNo = [tempDic objectForKey:@"order_no"];
    long long amount = [[tempDic objectForKey:@"amount"] longLongValue];
    NSString *subject = [tempDic objectForKey:@"subject"];
    NSString *channel = [tempDic objectForKey:@"channel"];
    // 将支付结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"payResult('%@', '%lld', '%@', '%@')", orderNo,amount,subject,channel];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
}

- (void)shakeAction {
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

- (void)goBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *URL = request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"haleyaction"]) {
        [self handleCustomAction:URL];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"var arr = [3, 4, 'abc'];"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
