//
//  RSVideoPlayerView.m
//  RSVideoPlayer
//
//  Created by 贾磊 on 16/1/20.
//  Copyright © 2016年 REEE INC. All rights reserved.
//

#import "RSVideoPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>

@implementation RSVideoPlayerView

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
#pragma mark- Control

-(void)showControlBar{
    if(self.delegate && [self.delegate respondsToSelector:@selector(showControlBar)]){
        [self.delegate showControlBar];
    }
}
-(void)singleTapHandle:(UITapGestureRecognizer *)tap{
    if(self.mControlBar.isHidden == YES){
        if(self.delegate && [self.delegate respondsToSelector:@selector(showControlBar:)]){
            [self.delegate showControlBar:YES];
        }
    }else{
        if(self.delegate && [self.delegate respondsToSelector:@selector(hideControlBar:)]){
            [self.delegate hideControlBar:YES];
        }
    }
}
-(void)doubleTapHandle:(UITapGestureRecognizer *)tap{
    if(self.delegate.isPlaying ==YES){
        if(self.delegate && [self.delegate respondsToSelector:@selector(pause)]){
            [self.delegate pause];
        }
    }else{
        if(self.delegate && [self.delegate respondsToSelector:@selector(play)]){
            [self.delegate play];
        }
    }
}
-(void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer{
    
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        self.panEventType = PlayerPanEventTypeNone;
        self.originPoint = [gestureRecognizer translationInView:gestureRecognizer.view];
        
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
       CGPoint changedPoint = [gestureRecognizer translationInView:gestureRecognizer.view];
        [self.panPoints addObject:[NSValue valueWithCGPoint:changedPoint]];
        //像素抽样
        if(self.panPoints.count %5 == 0){
            CGPoint point = [self.panPoints.lastObject CGPointValue];
            //快进或快退
            if(fabs(point.x) > fabs(point.y)){
                if(self.panEventType == PlayerPanEventTypeNone) self.panEventType = PlayerPanEventTypeForward;
            }else{//调节亮度和音量
//                if(point.x < 0){
//                    if(self.panEventType == PlayerPanEventTypeNone) self.panEventType = PlayerPanEventTypeVolume;
//                }else{
//                    if(self.panEventType == PlayerPanEventTypeNone) self.panEventType = PlayerPanEventTypeBrightness;
//                }
                if(self.panEventType == PlayerPanEventTypeNone) self.panEventType = PlayerPanEventTypeVolume;
            }
            
            if(self.panEventType == PlayerPanEventTypeForward){
                
                if(point.x > self.originPoint.x){
                    float value = self.mScrubber.value;
                    value += self.mScrubber.maximumValue*0.02;
                    [self.mScrubber setValue:value animated:YES];
                    [self.delegate beginScrubbing:self.mScrubber];
                    [self.delegate scrub:self.mScrubber];
                    
                }else{
                    float value = self.mScrubber.value;
                    value -= self.mScrubber.maximumValue*0.02;
                    [self.mScrubber setValue:value animated:YES];
                    [self.delegate beginScrubbing:self.mScrubber];
                    [self.delegate scrub:self.mScrubber];
                }
                
            }else if (self.panEventType == PlayerPanEventTypeVolume){
                if(point.y >self.originPoint.y){
                    [MPMusicPlayerController applicationMusicPlayer].volume -= 0.05;
                }else{
                    [MPMusicPlayerController applicationMusicPlayer].volume += 0.05;
                }
                //[MPMusicPlayerController applicationMusicPlayer].volume += 0.05;
            }else if (self.panEventType == PlayerPanEventTypeBrightness){
                //[UIScreen mainScreen].brightness += 0.05;
            }
            self.originPoint = point;
        }
        
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        if(self.panEventType == PlayerPanEventTypeForward) [self.delegate endScrubbing:self.mScrubber];
        self.panEventType = PlayerPanEventTypeNone;
        self.originPoint = CGPointZero;
        [self.panPoints removeAllObjects];
        
    }
    
}
-(void)beginScrubbing{
    if(self.delegate && [self.delegate respondsToSelector:@selector(beginScrubbing:)]){
        [self.delegate beginScrubbing:self.mScrubber];
    }
}
-(void)endScrubbing{
    if(self.delegate && [self.delegate respondsToSelector:@selector(endScrubbing:)]){
        [self.delegate endScrubbing:self.mScrubber];
    }
}
-(void)scrub{
    if(self.delegate && [self.delegate respondsToSelector:@selector(scrub:)]){
        [self.delegate scrub:self.mScrubber];
    }
}
-(void)play{
    if(self.delegate && [self.delegate respondsToSelector:@selector(play)]){
        [self.delegate play];
    }
}
-(void)pause{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pause)]){
        [self.delegate pause];
    }
}
-(void)launchFullScreen{
    if(self.delegate.showChangeHalfCourtButton == YES){
        [self showChangeHalfCourtBtn];
    }
    if(self.delegate.showGetButton == YES){
        [self showGetBtn];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(launchFullScreen)]){
        [self.delegate  launchFullScreen];
    }
}
- (void)minimizeVideo{
    [self hideChangeHalfCourtBtn];
    [self hideGetBtn];
    if(self.delegate && [self.delegate respondsToSelector:@selector(minimizeVideo)]){
        [self.delegate  minimizeVideo];
    }
}
-(void) changeHalfCourt{
    if(self.delegate && [self.delegate respondsToSelector:@selector(changeHalfCourt)]){
        [self.delegate changeHalfCourt];
    }
}
-(void) getVideo{
    if(self.delegate && [self.delegate respondsToSelector:@selector(getVideo)]){
        [self.delegate getVideo];
    }
}
-(void)showChangeHalfCourtBtn{
    self.mChangeHalfCourtButton.hidden = NO;
    self.halfCourtBtnWidthConstraint.constant = 75.f;
    self.halfCourtBtnHeightConstraint.constant = 28.f;
}
-(void)hideChangeHalfCourtBtn{
    self.mChangeHalfCourtButton.hidden = YES;
    self.halfCourtBtnWidthConstraint.constant = 0.f;
    self.halfCourtBtnHeightConstraint.constant = 0.f;
}

-(void)showGetBtn{
    self.mGetButton.hidden = NO;
    self.getBtnWidthConstraint.constant = 63.f;
    self.getBtnHeightConstraint.constant = 63.f;
}
-(void)hideGetBtn{
    self.mGetButton.hidden = YES;
    self.getBtnWidthConstraint.constant = 0.f;
    self.getBtnHeightConstraint.constant = 0.f;
}
#pragma mark- initialize

- (void)initialize
{
    [self addSubview:self.mBackgroundImageView];
    [self addSubview:self.mPlaybackView];
    [self addSubview:self.mControlBar];
    [self addSubview:self.mGetButton];
    [self.mControlBar addSubview:self.mPlayButton];
    [self.mControlBar addSubview:self.mPauseButton];
    [self.mControlBar addSubview:self.mPlayTimeLabel];
    //[self.mControlBar addSubview:self.mLoadProgressView];
    [self.mControlBar addSubview:self.mScrubber];
    [self.mControlBar addSubview:self.mTotalTimeLabel];
    [self.mControlBar addSubview:self.mChangeHalfCourtButton];
    [self.mControlBar addSubview:self.mFullScreenBtn];
    [self.mControlBar addSubview:self.mMiniScreenBtn];
    [self addConstraint];
    [self addGesture];
}
-(void)addGesture{
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    [self.mPlaybackView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandle:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.mPlaybackView addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.mPlaybackView addGestureRecognizer:panGesture];
    
}

-(void)addConstraint{
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self,_mBackgroundImageView,_mPlaybackView,_mControlBar,_mPlayButton,_mPauseButton,_mPlayTimeLabel,_mScrubber,_mTotalTimeLabel,_mFullScreenBtn);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mBackgroundImageView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mBackgroundImageView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mPlaybackView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mPlaybackView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    
//    //mIndicatorView
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mIndicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:100.f]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mIndicatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:20.f]];
//    
//    //mForwardReverseView
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mForwardReverseView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mForwardReverseView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mForwardReverseView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:150.f]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mForwardReverseView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:80.f]];
    
    //mControlBar
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mControlBar]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_mControlBar(44)]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    
    
    //_mPlayPauseButton
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mPlayButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mControlBar attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mPlayButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mControlBar attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mPlayButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mPlayButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.f]];
    
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mPauseButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mControlBar attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mPauseButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mControlBar attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mPauseButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mPauseButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.f]];
    //mPlayTimeLabel
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mPlayTimeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mPlayButton attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:8.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mPlayTimeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mPauseButton attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:8.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mPlayTimeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mControlBar attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mPlayTimeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40.f]];
    
    //mLoadProgressView
//    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mLoadProgressView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mPlayTimeLabel attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:8.f]];
//    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mLoadProgressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mControlBar attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:1.f]];
    
    //mScrubber
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mScrubber attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mPlayTimeLabel attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:8.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mScrubber attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mControlBar attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f]];
    
    //mTotalTimeLabel
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mTotalTimeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mScrubber attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:8.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mTotalTimeLabel  attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mControlBar attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mTotalTimeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40.f]];
    
    
    //changeHalfCourtButton
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mChangeHalfCourtButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mTotalTimeLabel attribute:NSLayoutAttributeTrailing multiplier:1.f constant:8.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mChangeHalfCourtButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mControlBar attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
    self.halfCourtBtnWidthConstraint = [NSLayoutConstraint constraintWithItem:self.mChangeHalfCourtButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.f];
    [self.mControlBar addConstraint:self.halfCourtBtnWidthConstraint];
    self.halfCourtBtnHeightConstraint = [NSLayoutConstraint constraintWithItem:self.mChangeHalfCourtButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.f];
    [self.mControlBar addConstraint:self.halfCourtBtnHeightConstraint];
    
    //mFullScreenBtn
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mFullScreenBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mChangeHalfCourtButton attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:10.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mFullScreenBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mControlBar attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-8.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mFullScreenBtn  attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mControlBar attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mFullScreenBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.f]];
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mFullScreenBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.f]];
    
    //mMiniScreenBtn
    [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mMiniScreenBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mFullScreenBtn attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.f]];
        [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mMiniScreenBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mFullScreenBtn attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.f]];
        [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mMiniScreenBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mFullScreenBtn attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f]];
        [self.mControlBar addConstraint:[NSLayoutConstraint constraintWithItem:self.mMiniScreenBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mFullScreenBtn attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.f]];
    
    
    //getBtn
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mGetButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.f constant:-8.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mGetButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
    self.getBtnWidthConstraint = [NSLayoutConstraint constraintWithItem:self.mGetButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.f];
    [self addConstraint:self.getBtnWidthConstraint];
    self.getBtnHeightConstraint = [NSLayoutConstraint constraintWithItem:self.mGetButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.f];
    [self addConstraint:self.getBtnHeightConstraint];

}
#pragma mark- Getter

-(UIImage *)imageNamed:(NSString *)name {
    NSString *fullname = [NSString stringWithFormat:@"RSVideoPlayer.bundle/%@",name];
    return [UIImage imageNamed:fullname];
}
-(UIImageView *)mBackgroundImageView{
    if(!_mBackgroundImageView){
        
        _mBackgroundImageView = [[UIImageView alloc] initWithImage:[self imageNamed:@"playerbg"]];
        _mBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        _mBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _mBackgroundImageView;
}
-(RSVideoPlayerLayerView *)mPlaybackView{
    if(!_mPlaybackView){
        _mPlaybackView = [[RSVideoPlayerLayerView alloc] init];
        _mPlaybackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _mPlaybackView;
}

-(UIView *)mControlBar{
    if(!_mControlBar){
        _mControlBar = [[UIView alloc] init];
        _mControlBar.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8];
        _mControlBar.translatesAutoresizingMaskIntoConstraints = NO;
        _mControlBar.hidden = YES;
    }
    return _mControlBar;
}
-(UIButton *)mPlayButton{
    if(!_mPlayButton){
        _mPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mPlayButton setImage:[self imageNamed:@"play"] forState:UIControlStateNormal];
        _mPlayButton.translatesAutoresizingMaskIntoConstraints = NO;
        _mPlayButton.hidden = YES;
        [_mPlayButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mPlayButton;
}
-(UIButton *)mPauseButton{
    if(!_mPauseButton){
        _mPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mPauseButton setImage:[self imageNamed:@"pause"] forState:UIControlStateNormal];
        _mPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
        _mPauseButton.hidden = YES;
        [_mPauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mPauseButton;
}
-(UIButton *)mFullScreenBtn{
    if(!_mFullScreenBtn){
        _mFullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mFullScreenBtn setImage:[self imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        _mFullScreenBtn.translatesAutoresizingMaskIntoConstraints = NO;
         [_mFullScreenBtn addTarget:self action:@selector(launchFullScreen) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mFullScreenBtn;
}
-(UIButton *)mMiniScreenBtn{
    if(!_mMiniScreenBtn){
        _mMiniScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mMiniScreenBtn setImage:[self imageNamed:@"mini"] forState:UIControlStateNormal];
        _mMiniScreenBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_mMiniScreenBtn addTarget:self action:@selector(minimizeVideo) forControlEvents:UIControlEventTouchUpInside];
        _mMiniScreenBtn.hidden = YES;
    }
    return _mMiniScreenBtn;
}
-(UILabel *)mPlayTimeLabel{
    if(!_mPlayTimeLabel){
        _mPlayTimeLabel = [[UILabel alloc] init];
        _mPlayTimeLabel.backgroundColor = [UIColor clearColor];
        _mPlayTimeLabel.textColor = [UIColor orangeColor];
        _mPlayTimeLabel.textAlignment = NSTextAlignmentCenter;
        _mPlayTimeLabel.font = [UIFont systemFontOfSize:12];
        _mPlayTimeLabel.text = @"00:00";
        _mPlayTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _mPlayTimeLabel;
}
-(UILabel *)mTotalTimeLabel{
    if(!_mTotalTimeLabel){
        _mTotalTimeLabel = [[UILabel alloc] init];
        _mTotalTimeLabel.backgroundColor = [UIColor clearColor];
        _mTotalTimeLabel.textColor = [UIColor orangeColor];
        _mTotalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _mTotalTimeLabel.font = [UIFont systemFontOfSize:12];
        _mTotalTimeLabel.text = @"00:00";
        _mTotalTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _mTotalTimeLabel;
}
//-(UIProgressView *)mLoadProgressView{
//    if(!_mLoadProgressView){
//        _mLoadProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//        _mLoadProgressView.translatesAutoresizingMaskIntoConstraints = NO;
//        _mLoadProgressView.hidden = YES;
//    }
//    return _mLoadProgressView;
//}
-(UISlider *)mScrubber{
    if(!_mScrubber){
        _mScrubber = [[UISlider alloc]init];
        [_mScrubber setThumbImage:[self imageNamed:@"thumb"] forState:UIControlStateNormal];
        [_mScrubber setThumbImage:[self imageNamed:@"thumb"] forState:UIControlStateHighlighted];
        [_mScrubber setMinimumTrackImage:[[self imageNamed:@"sliderbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [_mScrubber setMinimumTrackImage:[[self imageNamed:@"sliderbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
        [_mScrubber setMaximumTrackImage:[self imageNamed:@"sliderbg"]  forState:UIControlStateNormal];
        [_mScrubber setMaximumTrackImage:[self imageNamed:@"sliderbg"]  forState:UIControlStateHighlighted];
        
        _mScrubber.translatesAutoresizingMaskIntoConstraints = NO;
        [_mScrubber addTarget:self action:@selector(scrub) forControlEvents:UIControlEventValueChanged ];
        [_mScrubber addTarget:self action:@selector(beginScrubbing) forControlEvents:UIControlEventTouchDown];
        [_mScrubber addTarget:self action:@selector(endScrubbing) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _mScrubber;
}
-(NSMutableArray *)panPoints{
    if(!_panPoints){
        _panPoints = [@[] mutableCopy];
    }
    return _panPoints;
}

-(UIButton *)mChangeHalfCourtButton{
    if(!_mChangeHalfCourtButton){
        _mChangeHalfCourtButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mChangeHalfCourtButton setImage:[UIImage imageNamed:@"半场切换"] forState:UIControlStateNormal];
        _mChangeHalfCourtButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_mChangeHalfCourtButton addTarget:self action:@selector(changeHalfCourt) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mChangeHalfCourtButton;
}
-(UIButton *)mGetButton{
    if(!_mGetButton){
        _mGetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mGetButton setImage:[UIImage imageNamed:@"GET-按钮--小"] forState:UIControlStateNormal];
        _mGetButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_mGetButton addTarget:self action:@selector(getVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mGetButton;
}
@end
