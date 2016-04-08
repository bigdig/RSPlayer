//
//  RSVideoPlayerForwardReverseView.m
//  RSVideoPlayer
//
//  Created by 贾磊 on 16/1/28.
//  Copyright © 2016年 REEE INC. All rights reserved.
//

#import "RSVideoPlayerForwardReverseView.h"

@implementation RSVideoPlayerForwardReverseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc
{
    NSLog(@"%@ dealloc",self);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


+(void)forwardWithPlayTime:(NSString *)playTime totalTime:(NSString *)totalTime progress:(CGFloat)progress view:(UIView *)view {
    RSVideoPlayerForwardReverseView *forwardReverseView = [self forwardReverseViewWith:view];
    if(!forwardReverseView){
        forwardReverseView = [[RSVideoPlayerForwardReverseView alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
        [view addSubview:forwardReverseView];
        forwardReverseView.center = view.center;
    }
    forwardReverseView.forwardReverseImageView.image = [UIImage imageNamed:@"RSVideoPlayer.bundle/forward"];
    forwardReverseView.playTimeLabel.text = [NSString stringWithFormat:@"%@/",playTime];
    forwardReverseView.totalTimeLabel.text = totalTime;
    forwardReverseView.progressView.progress = progress;
}

+(void)reverseWithPlayTime:(NSString *)playTime totalTime:(NSString *)totalTime progress:(CGFloat)progress view:(UIView *)view {
    RSVideoPlayerForwardReverseView *forwardReverseView = [self forwardReverseViewWith:view];
    if(!forwardReverseView){
        forwardReverseView = [[RSVideoPlayerForwardReverseView alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
        [view addSubview:forwardReverseView];
        forwardReverseView.center = view.center;
    }
    forwardReverseView.forwardReverseImageView.image = [UIImage imageNamed:@"RSVideoPlayer.bundle/reverse"];
    forwardReverseView.playTimeLabel.text = [NSString stringWithFormat:@"%@/",playTime];
    forwardReverseView.totalTimeLabel.text = totalTime;
    forwardReverseView.progressView.progress = progress;
}

+(void)hideForwardReverseView:(UIView *)view {
    
    RSVideoPlayerForwardReverseView *forwardReverseView = [self forwardReverseViewWith:view];
    if(forwardReverseView){
        [forwardReverseView removeFromSuperview];
    }
}


+(RSVideoPlayerForwardReverseView *)forwardReverseViewWith:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (RSVideoPlayerForwardReverseView *)subview;
        }
    }
    return nil;
}


- (void)initialize
{
    [self addSubview:self.forwardReverseImageView];
    [self addSubview:self.totalTimeLabel];
    [self addSubview:self.playTimeLabel];
    [self addSubview:self.progressView];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
    //image
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.forwardReverseImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.forwardReverseImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:10.f]];
    
    //playbackTime
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.playTimeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:8.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.playTimeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.forwardReverseImageView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:8.f]];
    //totalTime

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.forwardReverseImageView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:8.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-8.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.playTimeLabel attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.playTimeLabel attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.playTimeLabel attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.f]];
    //progress
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:8.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-8.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-8.f]];
    return;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self,_forwardReverseImageView,_playTimeLabel,_totalTimeLabel,_progressView);
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.forwardReverseImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.playTimeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:8.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.playTimeLabel attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.playTimeLabel attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-8.f]];
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_forwardReverseImageView]-8-[_totalTimeLabel(15)]-8-[_progressView]-8-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_progressView]-8-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    

    
    
}
-(UIImageView *)forwardReverseImageView{
    if(!_forwardReverseImageView){
        _forwardReverseImageView = [[UIImageView alloc] init];
        _forwardReverseImageView.image = [UIImage imageNamed:@"RSVideoPlayer.bundle/forward"];
        _forwardReverseImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _forwardReverseImageView;
}
-(UILabel *)playTimeLabel{
    if(!_playTimeLabel){
        _playTimeLabel = [[UILabel alloc] init];
        _playTimeLabel.backgroundColor = [UIColor clearColor];
        _playTimeLabel.textColor = [UIColor orangeColor];
        _playTimeLabel.font = [UIFont systemFontOfSize:12];
        _playTimeLabel.textAlignment = NSTextAlignmentRight;
        _playTimeLabel.text = @"00:00";
        _playTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _playTimeLabel;
}
-(UILabel *)totalTimeLabel{
    if(!_totalTimeLabel){
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.backgroundColor = [UIColor clearColor];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:12];
        _totalTimeLabel.textAlignment = NSTextAlignmentLeft;
        _totalTimeLabel.text = @"/00:00";
        _totalTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _totalTimeLabel;
}
-(UIProgressView *)progressView{
    if(!_progressView){
        _progressView = [[UIProgressView alloc] init];
        _progressView.trackImage = [UIImage imageNamed:@"RSVideoPlayer.bundle/progressbg"];
        _progressView.progressImage = [UIImage imageNamed:@"RSVideoPlayer.bundle/progressbar"];
        _progressView.progress = 0.5f;
        _progressView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _progressView;
}
@end
