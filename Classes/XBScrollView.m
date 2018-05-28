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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (change[@"new"]) {
        CGPoint point = [(NSValue *)change[@"new"] CGPointValue];
        NSLog(@"%f",point.y);
        if (point.y <= -CGRectGetHeight(self.headerView.frame)) {
            // scrollView已经下拉到顶部 这个时候要将headerView固定在Y=0的位置
            self.headerView.frame = CGRectMake(CGRectGetMinX(self.headerView.frame), 0, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame));
        } else if (point.y >= -self.headerOffset) {
            // scrollView已经滚动超过headerView的高度 需要将headerView的位置固定在 Y = - headerView.height的位置
            CGFloat y = -(CGRectGetHeight(self.headerView.frame) - self.headerOffset);
            self.headerView.frame = CGRectMake(CGRectGetMinX(self.headerView.frame), y, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame));
            self.scrollView.contentInset = UIEdgeInsetsMake(self.headerOffset, 0, 0, 0);
        } else {
            // y = -headerView.height - point.y
            self.headerView.frame = CGRectMake(CGRectGetMinX(self.headerView.frame), -CGRectGetHeight(self.headerView.frame)  - point.y, CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame));
            self.scrollView.contentInset = UIEdgeInsetsMake(fabs(point.y), 0, 0, 0);
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

- (void)setHeaderOffset:(CGFloat)headerOffset
{
    headerOffset = fabs(headerOffset);
    _headerOffset = headerOffset;
}

- (void)dealloc
{
    _headerView = nil;
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    _scrollView = nil;
}
@end
