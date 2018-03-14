//
//  ViewController.m
//  WKWebViewInterceptTest1
//
//  Created by xiaohui on 2018/3/14.
//  Copyright © 2018年 XIAOHUI. All rights reserved.
//

#import "ViewController.h"
#import "UIWebViewLocalTestVC.h"
#import "LocalTestVC.h"
#import "RemoteTestVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"网页拦截测试";
}

- (IBAction)uiWebViewLocalTest:(id)sender {
    UIWebViewLocalTestVC *vc = [[UIWebViewLocalTestVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)localTest:(id)sender {
    LocalTestVC *vc = [[LocalTestVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)remoteTest:(id)sender {
    RemoteTestVC *vc = [[RemoteTestVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
