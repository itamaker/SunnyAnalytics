//  ViewController.m
//Copyright (c) 2015-2017 Sunny Software Foundation
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

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
