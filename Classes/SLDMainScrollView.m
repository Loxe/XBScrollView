//
//  SLDMainScrollView.m
//  SLDPro
//
//  Created by Binbin on 17/10/27.
//  Copyright © 2017年 XB. All rights reserved.
//

#import "SLDMainScrollView.h"
@interface SLDMainScrollView()

@end

@implementation SLDMainScrollView

- (instancetype)initWithFrame:(CGRect)frame tableView:(UITableView *)tableView headerView:(UIView *)headerView
{
    return [self initWithFrame:frame scrollView:tableView headerView:headerView];
}

- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView headerView:(UIView *)headerView
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollView = scrollView;
        self.headerView = headerView;
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetHeight(self.headerView.frame), 0, 0, 0);
        self.scrollView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.headerView.frame), 0, 0, 0);
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [self addSubViewAction];
        [self removeNowGestureRecognizerToAddNewGestureRecognizers:self.scrollView.gestureRecognizers];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame webView:(UIWebView *)webView headerView:(UIView *)headerView
{
    self = [super initWithFrame:frame];
    if (self) {
        
        webView.frame = CGRectMake(CGRectGetMinX(webView.frame), CGRectGetHeight(self.headerView.frame), CGRectGetWidth(webView.frame), frame.size.height - CGRectGetHeight(self.headerView.frame));
        self.scrollView = webView.scrollView;
        self.headerView = headerView;
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetHeight(self.headerView.frame), 0, 0, 0);
        self.scrollView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.headerView.frame), 0, 0, 0);
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self addSubViewAction];
        [self removeNowGestureRecognizerToAddNewGestureRecognizers:self.scrollView.gestureRecognizers];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (change[@"new"]) {
        CGPoint point = [(NSValue *)change[@"new"] CGPointValue];
        if (point.y <= -CGRectGetHeight(self.headerView.frame)) {
            // y = 0
            self.headerView.frame = CGRectMake(CGRectGetMinX(self.headerView.frame), 0, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame));
        } else if (point.y >= 0) {
            // y = -headerView.height
            self.headerView.frame = CGRectMake(CGRectGetMinX(self.headerView.frame), -CGRectGetHeight(self.headerView.frame), CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame));
        } else {
            // y = -headerView.height - point.y
            self.headerView.frame = CGRectMake(CGRectGetMinX(self.headerView.frame), -CGRectGetHeight(self.headerView.frame)  - point.y, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame));
        }
    }
}

- (void)removeNowGestureRecognizerToAddNewGestureRecognizers:(NSArray *)gestureRecognizers {
    //移除主scrollView原有手势操作
    NSMutableArray *list = [NSMutableArray arrayWithArray:self.gestureRecognizers];
    for (UIGestureRecognizer *gestureRecognizer in list) {
        [self removeGestureRecognizer:gestureRecognizer];
    }
    //将需要的手势操作加到主scrollView中
    for (UIGestureRecognizer *gestureRecognizer in gestureRecognizers) {
        [self addGestureRecognizer:gestureRecognizer];
    }
}

- (void)addSubViewAction
{
    CGRect headerViewFrame = self.headerView.frame;
    CGRect scrollViewFrame = self.scrollView.frame;
    headerViewFrame.origin.y = 0;
    scrollViewFrame.origin.y = headerViewFrame.size.height;
    
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
