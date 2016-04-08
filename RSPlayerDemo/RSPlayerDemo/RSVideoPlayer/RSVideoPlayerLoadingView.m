//
//  RSVideoPlayerLoadingView.m
//  RSVideoPlayer
//
//  Created by 贾磊 on 16/1/27.
//  Copyright © 2016年 REEE INC. All rights reserved.
//

#import "RSVideoPlayerLoadingView.h"

@implementation RSVideoPlayerLoadingView

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
+(void)startLoadingInView:(UIView *)view{
    
    RSVideoPlayerLoadingView *loadingview = [self loadingViewForView:view];
    if(!loadingview){
        loadingview = [[RSVideoPlayerLoadingView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [view addSubview:loadingview];
        loadingview.center = view.center;
        [loadingview startAnimating];
    }
}
+(void)stopLoadingInView:(UIView *)view{
    RSVideoPlayerLoadingView *loadingview = [self loadingViewForView:view];
    if(loadingview){
        [loadingview stopAnimating];
        [loadingview removeFromSuperview];
    }
}
+(RSVideoPlayerLoadingView *)loadingViewForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (RSVideoPlayerLoadingView *)subview;
        }
    }
    return nil;
}

- (void)initialize
{
    [self addSubview:self.cycleImageView];
    [self addSubview:self.titleLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cycleImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cycleImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cycleImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:20]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.cycleImageView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
    
}
- (void)startAnimating{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.delegate = self;
    [self.cycleImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
-(void)stopAnimating{
    [self.cycleImageView.layer removeAnimationForKey:@"rotationAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(flag){
        [self startAnimating];
    }
}

-(UIImageView *)cycleImageView{
    if(!_cycleImageView){
        _cycleImageView = [[UIImageView alloc] init];
        _cycleImageView.image = [UIImage imageNamed:@"RSVideoPlayer.bundle/loading"];
        _cycleImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cycleImageView;
}
-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor orangeColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"玩命加载中...";
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}
@end
