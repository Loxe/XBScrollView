//
//  ViewController.m
//  XBScrollViewDemo
//
//  Created by Binbin on 17/11/21.
//  Copyright © 2017年 XB. All rights reserved.
//

#import "ViewController.h"
#import "XBScrollView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()
@property (nonatomic, strong) XBScrollView *mainScrollView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *bodyScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainScrollView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (XBScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[XBScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds scrollView:self.bodyScrollView headerView:self.headerView];
    }
    return _mainScrollView;
}


- (UIView *)headerView
{
    if (!_headerView ) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _headerView.backgroundColor = [UIColor blueColor];
    }
    return _headerView;
}

- (UIScrollView *)bodyScrollView
{
    if (!_bodyScrollView) {
        _bodyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bodyScrollView.contentSize = CGSizeMake(kScreenWidth, 1000);
        _bodyScrollView.backgroundColor = [UIColor redColor];
        for (int i = 0; i < 10; i ++) {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, i*100, kScreenWidth, 100)];
            if (i == 0 || i == 9) {
                v.backgroundColor = [UIColor blackColor];
                
            } else {
                v.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:arc4random()%101/100.f];
            }
            [_bodyScrollView addSubview:v];
        }
    }
    return _bodyScrollView;
}
@end
