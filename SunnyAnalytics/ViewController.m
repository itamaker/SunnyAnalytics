//
//  ViewController.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright © 2015年 gitpark. All rights reserved.
//

#import "ViewController.h"
#import "SAAnalytics.h"


#define sa_BtnClicked @"btn_click"
#define sa_ClassicPage @"page_view_customerInterviewVideo"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

-(void)initViews{
    UIButton *buttonTest = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonTest setTitle:@"事件统计" forState:UIControlStateNormal];
    buttonTest.backgroundColor = [UIColor redColor];
    buttonTest.frame = CGRectMake(self.view.center.x-100, self.view.center.y, 200, 30);
    [buttonTest addTarget:self action:@selector(actionTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonTest];
}


#pragma mark - 统计事件
-(void)actionTest{
    [SAAnalytics doEvent:sa_BtnClicked objectId:nil params:nil];
}

#pragma mark - 统计页面
-(void)viewWillAppear:(BOOL)animated
{
    [SAAnalytics beginPage:sa_ClassicPage];
    [super viewWillAppear:animated];
}

#pragma mark - 统计页面
-(void)viewWillDisappear:(BOOL)animated
{
    [SAAnalytics endPage:sa_ClassicPage];
    [super viewWillDisappear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
