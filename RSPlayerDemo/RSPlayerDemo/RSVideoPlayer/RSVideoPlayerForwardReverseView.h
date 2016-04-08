//
//  RSVideoPlayerForwardReverseView.h
//  RSVideoPlayer
//
//  Created by 贾磊 on 16/1/28.
//  Copyright © 2016年 REEE INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSVideoPlayerForwardReverseView : UIView

@property (nonatomic , strong) UIImageView *forwardReverseImageView;
@property (nonatomic , strong) UILabel *playTimeLabel;
@property (nonatomic , strong) UILabel *totalTimeLabel;
@property (nonatomic , strong) UIProgressView *progressView;
@property (nonatomic , assign) float lastPlaybackTime;

+(void)forwardWithPlayTime:(NSString *)playTime totalTime:(NSString *)totalTime progress:(CGFloat)progress view:(UIView *)view;
+(void)reverseWithPlayTime:(NSString *)playTime totalTime:(NSString *)totalTime progress:(CGFloat)progress view:(UIView *)view;
+(void)hideForwardReverseView:(UIView *)view;

@end
