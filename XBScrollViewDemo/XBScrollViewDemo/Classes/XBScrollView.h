//
//  XBScrollView.h
//  SLDPro
//
//  Created by Binbin on 17/10/27.
//  Copyright © 2017年 XB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBScrollView : UIScrollView
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *headerView;
- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView headerView:(UIView *)headerView;

@end
