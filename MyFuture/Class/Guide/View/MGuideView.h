//
//  MGuideView.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/7.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGuideView : UIView
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray *slideImages;
@property (strong,nonatomic) UIPageControl *pageControl;
- (void)btnAction:(UIButton *)sender;

@end
