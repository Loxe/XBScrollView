//
//  XBScrollView.m
//  SLDPro
//
//  Created by Binbin on 17/10/27.
//  Copyright © 2017年 XB. All rights reserved.
//

#import "XBScrollView.h"
@interface XBScrollView()

@end

@implementation XBScrollView


- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView headerView:(UIView *)headerView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = scrollView;
        self.headerView = headerView;
        //滚动指示器偏移
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(-CGRectGetHeight(self.headerView.frame), 0, 0, 0);
        //内容偏移量
        self.scrollView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.headerView.frame), 0, 0, 0 );
        //contentOffset初始位置
        self.scrollView.contentOffset = CGPointMake(0, -CGRectGetHeight(self.headerView.frame));
        //重新监听contentOffset用于处理headerView
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self addSubViewAction];
        [self gesReset:self.scrollView.gestureRecognizers];
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (change[@"new"]) {
        CGPoint point = [(NSValue *)change[@"new"] CGPointValue];
        if (point.y <= -CGRectGetHeight(self.headerView.frame)) {
            self.headerView.frame = CGRectMake(CGRectGetMinX(self.headerView.frame), 0, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame));
        } else if (point.y >= CGRectGetHeight(self.headerView.frame)) {
            self.headerView.frame = CGRectMake(CGRectGetMinX(self.headerView.frame), -CGRectGetHeight(self.headerView.frame), CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame));
        } else {
            self.headerView.frame = CGRectMake(CGRectGetMinX(self.headerView.frame), -CGRectGetHeight(self.headerView.frame)-point.y, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame));
        }
    }
}

- (void)gesReset:(NSArray *)gestureRecognizers {
    //移除主scrollView原有手势操作
    NSMutableArray *list = [NSMutableArray arrayWithArray:self.gestureRecognizers];
    for (UIGestureRecognizer *gestureRecognizer in list) {
        [self removeGestureRecognizer:gestureRecognizer];
    }
    //将需要的手势操作加到主scrollView中
    for (UIGestureRecognizer *gestureRecognizer in gestureRecognizers) {
        [self addGestureRecognizer:gestureRecognizer];
    }
    //这样即使在scrollview以外的地方滑动也可以操作scrollView
}

- (void)addSubViewAction
{
    CGRect headerFrame = self.headerView.frame;
    CGRect scrollViewFrame = self.scrollView.frame;
    
    headerFrame.origin.y = 0;
    scrollViewFrame.origin.y = 0;
    scrollViewFrame.size.height = self.frame.size.height;
    self.headerView.frame = headerFrame;
    self.scrollView.frame = scrollViewFrame;
    [self addSubview:self.scrollView];
    [self addSubview:self.headerView];
}

- (void)dealloc
{
    _headerView = nil;
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    _scrollView = nil;
}
@end
