//
//  RSVideoPlayerLoadingView.h
//  RSVideoPlayer
//
//  Created by 贾磊 on 16/1/27.
//  Copyright © 2016年 REEE INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSVideoPlayerLoadingView : UIView
@property (nonatomic , strong) UIImageView *cycleImageView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , assign) BOOL isAnimating;


+(void)startLoadingInView:(UIView *)view;
+(void)stopLoadingInView:(UIView *)view;

@end
