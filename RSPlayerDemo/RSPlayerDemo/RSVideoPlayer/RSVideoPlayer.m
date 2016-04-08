//
//  RSVideoPlayer.m
//  RSVideoPlayer
//
//  Created by 贾磊 on 16/1/20.
//  Copyright © 2016年 REEE INC. All rights reserved.
//

#import "RSVideoPlayer.h"


@implementation RSVideoPlayer


- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        [self initializeWithView:view];
    }
    return self;
}
- (void)dealloc
{
    NSLog(@"%@ dealloc",self);
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.mPlayerItem = nil;
    self.mPlayer = nil;
    self.mTimeObserver = nil;
    [self.mPlayer pause];
}
#pragma mark- initialize
- (void)initializeWithView:(UIView *)view{
    self.superView = view;
    [view addSubview:self.mView];

    NSDictionary *views = NSDictionaryOfVariableBindings(view, _mView);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:UIApplicationWillResignActiveNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(play) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark- Getter
-(RSVideoPlayerView *)mView{
    if(!_mView){
        _mView = [[RSVideoPlayerView alloc] init];
        _mView.translatesAutoresizingMaskIntoConstraints = NO;
        _mView.delegate = self;
    }
    return _mView;
}
#pragma mark- Setter
-(void)setMPlayerItem:(AVPlayerItem *)mPlayerItem{
    if(_mPlayerItem){
        [_mPlayerItem removeObserver:self forKeyPath:@"status"];
        [_mPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_mPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [_mPlayerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_mPlayerItem];
    }
    
    _mPlayerItem = mPlayerItem;
    
    if (_mPlayerItem) {
        [_mPlayerItem addObserver:self forKeyPath:@"status" options: NSKeyValueObservingOptionNew context:AVPlayerItemObservationContext];
        [_mPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:AVPlayerItemObservationContext];
        [_mPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:AVPlayerItemObservationContext];
        [_mPlayerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew context:AVPlayerItemObservationContext];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_mPlayerItem];
    }

}
-(void)setMPlayer:(AVPlayer *)mPlayer{
    self.mTimeObserver = nil;
    if(_mPlayer){
        [_mPlayer removeObserver:self forKeyPath:@"rate"];
        [_mPlayer removeObserver:self forKeyPath:@"currentItem"];
    }
    
    _mPlayer = mPlayer;
    
    if (mPlayer) {
        [self.mPlayer addObserver:self
                       forKeyPath:@"currentItem"
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:AVPlayerObservationContext];
        
        [self.mPlayer addObserver:self
                       forKeyPath:@"rate"
                          options: NSKeyValueObservingOptionNew
                          context:AVPlayerObservationContext];
        
        __weak typeof(self) weakSelf = self;
        self.mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.f, NSEC_PER_SEC)
                                                                        queue:NULL /* If you pass NULL, the main queue is used. */
                                                                   usingBlock:^(CMTime time)
                              {
                                  [weakSelf syncScrubberAndTimeLabel];
                              }];
    }
}
-(void)setMTimeObserver:(id)mTimeObserver{
    if(_mTimeObserver){
          [self.mPlayer removeTimeObserver:_mTimeObserver];
    }
    _mTimeObserver = mTimeObserver;
}

#pragma mark- Core

- (void)setURL:(NSURL*)URL
{
    //[self stop];
    self.matchId = nil;
    self.videoId = nil;
    self.videoType = nil;
    self.seekTime = kCMTimeZero;
    self.seekToTimeBeforePlay = NO;
    self.isSeeking = NO;
    self.isScrubbing = NO;
    self.isUserPause = NO;
    self.state = RSVideoPlayerStateUnknown;
    _mURL = [URL copy];
    
    [self prepareToPlayURL:URL];
}
- (void)setURL:(NSURL*)URL seekToTime:(CMTime)time{
    [self setURL:URL];
    self.seekTime = time;
    self.seekToTimeBeforePlay = YES;
}
-(NSString *)contentURL{
    return _mURL ? _mURL.absoluteString : @"";
}

- (void)play
{
    if (YES == self.seekToTimeBeforePlay)
    {
        __weak typeof(self) weakself = self;
        [self seekToTime:self.seekTime completionHandler:^(BOOL finished) {
            weakself.seekToTimeBeforePlay = NO;
            weakself.seekTime = kCMTimeZero;
        }];
    }
    [self.mPlayer play];
    [self showStopButton];
    self.state = RSVideoPlayerStatePlaying;
    self.isUserPause = NO;
}
- (void)pause
{
    [self.mPlayer pause];
    [self showPlayButton];
    self.state = RSVideoPlayerStatePause;
    self.isUserPause = YES;
}

-(void)stop{
    NSLog(@"stop");
    [self addRSCountlyEvent];
    [self hideControlBar];
    [self pause];
    self.mPlayerItem = nil;
    self.mPlayer = nil;
    self.mTimeObserver = nil;
    [self.mPlayer.currentItem  cancelPendingSeeks];
    [self.mPlayer.currentItem.asset cancelLoading];
    self.state = RSVideoPlayerStateStop;
    
}
-(void)addRSCountlyEvent{

    if(self.delegate && [self.delegate respondsToSelector:@selector(videoPlayer:recordURL:playBackTime:)]){
        CGFloat currentTime = self.currentPlaybackTime;
        if(currentTime >0 && self.mURL){
            [self.delegate videoPlayer:self recordURL:self.mURL playBackTime:currentTime];
        }
    }
}
-(void)seekToTime:(CMTime)time{
    [self seekToTime:time completionHandler:nil];
}
- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler{
    [self.mPlayer seekToTime:time completionHandler:completionHandler];
}

-(void)prepareToPlayURL:(NSURL *)URL{
    
    self.mPlayerItem = [[AVPlayerItem alloc] initWithURL:URL];
    if (!self.mPlayer)
    {
        self.mPlayer = [AVPlayer playerWithPlayerItem:self.mPlayerItem];
    }else{
        if (self.mPlayer.currentItem != self.mPlayerItem)
        {
            [self addRSCountlyEvent];
            [self.mPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem];
        }
    }
    [self.mView.mPlaybackView setPlayer:self.mPlayer];
    [self.mView.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
    self.state = RSVideoPlayerStatePrepareToPlay;
    
}
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    self.seekTime = kCMTimeZero;
    self.seekToTimeBeforePlay = YES;
    self.mView.mControlBar.hidden= NO;
    [self disableAutoHideControlbar];
    [self showPlayButton];
}
-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    /* Display the error. */
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"播放失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [self.mPlayer currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        return([playerItem duration]);
    }
    return(kCMTimeInvalid);
}
- (CMTime)playerItemCurrentTime{
    CMTime currentTime = [[self.mPlayer currentItem] currentTime];
    if(CMTIME_IS_INVALID(currentTime) || currentTime.value<0){
        currentTime = kCMTimeZero;
    }
    
    return currentTime;
}
-(float)currentPlaybackTime{
    CMTime currentTime = [[self.mPlayer currentItem] currentTime];
    if(CMTIME_IS_INVALID(currentTime) || currentTime.value<=0){
        return 0.f;
    }
    return currentTime.value/currentTime.timescale;
}
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.mPlayer currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}
- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    if (context == AVPlayerItemObservationContext)
    {
        if([path isEqualToString:@"status"]){
            AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (status)
            {
                case AVPlayerItemStatusUnknown:
                {
                    self.state = RSVideoPlayerStateUnknown;
                    [self hideControlBar];
                }
                    break;
                    
                case AVPlayerItemStatusReadyToPlay:
                {
                    [self showControlBar];
                    if(!self.isUserPause ){
                        [self play];
                    }
                }
                    break;
                    
                case AVPlayerItemStatusFailed:
                {
                    [self stop];
                    AVPlayerItem *playerItem = (AVPlayerItem *)object;
                    [self assetFailedToPrepareForPlayback:playerItem.error];
                    self.state = RSVideoPlayerStateError;
                }
                    break;
            }
        }else if ([path isEqualToString:@"playbackBufferEmpty"]){
            if(self.mPlayerItem.playbackBufferEmpty){
                NSLog(@"playbackBufferEmpty");
                [RSVideoPlayerLoadingView startLoadingInView:self.mView];
                self.state =  RSVideoPlayerStateLoading;
            }
            
        }else if ([path isEqualToString:@"playbackLikelyToKeepUp"]){
            if(self.mPlayerItem.playbackLikelyToKeepUp){
                NSLog(@"playbackLikelyToKeepUp");
                [RSVideoPlayerLoadingView stopLoadingInView:self.mView];
                self.state =  RSVideoPlayerStatePlaying;
            }
           
        }
    }
    else if (context == AVPlayerObservationContext)
    {
        if([path isEqualToString:@"rate"]){
            [self syncPlayPauseButtons];
        }else if([path isEqualToString:@"currentItem"]){
            AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        }
    }
    else
    {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}

#pragma mark- UI control

-(void)setState:(RSVideoPlayerState)state{
    _state = state;
    NSLog(@"state = %ld",state);
}
-(void)showStopButton
{
    self.mView.mPlayButton.hidden = YES;
    self.mView.mPauseButton.hidden = NO;
}
-(void)showPlayButton
{
    self.mView.mPlayButton.hidden = NO;
    self.mView.mPauseButton.hidden = YES;
}
- (void)syncPlayPauseButtons
{
    if ([self isPlaying])
    {
        [self showStopButton];
    }
    else
    {
        [self showPlayButton];
    }
}

-(void)showControlBar
{
    [self showControlBar:NO];
}
-(void)showControlBar:(BOOL)animated{
    if(self.mView.mControlBar.isHidden == YES){
        if(animated){
            self.mView.mControlBar.hidden = NO;
            __weak typeof(self) weakself = self;
            self.mView.mControlBar.alpha = 0.f;
            [UIView animateWithDuration:0.3f animations:^{
                weakself.mView.mControlBar.alpha = 1.f;
            } completion:^(BOOL finished) {
                [weakself enableAutoHideControlbar];
            }];
        }else{
            self.mView.mControlBar.hidden = NO;
            [self enableAutoHideControlbar];
        }
    }
}
-(void)enableAutoHideControlbar{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hideControlBar) withObject:nil afterDelay:5.0f];
}
-(void)disableAutoHideControlbar{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
-(void)hideControlBar
{
    [self hideControlBar:NO];
}
-(void)hideControlBar:(BOOL)animated{
    if(self.mView.mControlBar.hidden == NO){
        if(animated){
            self.mView.mControlBar.alpha = 1.f;
            __weak typeof(self) weakself = self;
            [UIView animateWithDuration:0.3f animations:^{
                weakself.mView.mControlBar.alpha = 0.f;
            } completion:^(BOOL finished) {
                weakself.mView.mControlBar.hidden = YES;
            }];
        }else{
            self.mView.mControlBar.hidden = YES;
        }
    }
}
- (void)syncScrubberAndTimeLabel
{
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        self.mView.mScrubber.minimumValue = 0.f;
        self.mView.mScrubber.maximumValue = 1.f;
        self.mView.mScrubber.value = 0.f;
        self.mView.mPlayTimeLabel.text = @"00:00";
        self.mView.mTotalTimeLabel.text = @"00:00";
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    self.mView.mScrubber.minimumValue = 0.0;
    self.mView.mScrubber.maximumValue = duration;

    self.mView.mTotalTimeLabel.text = [self convertTime:duration];
    if(!self.isScrubbing && !self.isSeeking){
        CMTime currentTime = [self playerItemCurrentTime];
        self.mView.mPlayTimeLabel.text = [self convertTime:CMTimeGetSeconds(currentTime)];
        [self.mView.mScrubber setValue:CMTimeGetSeconds(currentTime)];
    }
}
- (void)beginScrubbing:(UISlider *)slider
{
    [self disableAutoHideControlbar];
    self.isScrubbing = YES;
}
- (void)scrub:(UISlider *)slider
{
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    float playTime = [slider value];
    float totalTime = [slider maximumValue];
    self.mView.mPlayTimeLabel.text = [self convertTime:playTime];
    if(playTime > self.lastScrubTime){
        [RSVideoPlayerForwardReverseView forwardWithPlayTime:self.mView.mPlayTimeLabel.text totalTime:self.mView.mTotalTimeLabel.text progress:playTime/totalTime view:self.mView];
    }else{
        [RSVideoPlayerForwardReverseView reverseWithPlayTime:self.mView.mPlayTimeLabel.text totalTime:self.mView.mTotalTimeLabel.text progress:playTime/totalTime view:self.mView];
    }
    self.lastScrubTime = playTime;
}
- (void)endScrubbing:(UISlider *)slider
{
    [self enableAutoHideControlbar];
    self.seekToTimeBeforePlay = NO;
    self.isScrubbing = NO;
    self.lastScrubTime = 0;
    [RSVideoPlayerForwardReverseView hideForwardReverseView:self.mView];
    
    if (!self.isSeeking)
    {
        self.isSeeking = YES;
        float time = [slider value];
        __weak typeof(self) weakself = self;
        [self seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself play];
                weakself.isSeeking = NO;
            });
        }];
    }
}
-(void)enableScrubber
{
    self.mView.mScrubber.enabled = YES;
}
-(void)disableScrubber
{
    self.mView.mScrubber.enabled = NO;
}
- (BOOL)isPlaying
{
    return  [self.mPlayer rate] != 0.f;
}

- (void)launchFullScreen
{
    self.mView.mFullScreenBtn.enabled= NO;
    if (!self.fullScreenViewController) {
        self.fullScreenViewController = [[RSVideoPlayerFullScreenViewController alloc] init];
    }
    [self.fullScreenViewController.view addSubview:self.mView];
    NSDictionary *views = NSDictionaryOfVariableBindings(_mView);
    [self.fullScreenViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mView]-0-|" options:0 metrics:nil views:views]];
    [self.fullScreenViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mView]-0-|" options:0 metrics:nil views:views]];
    self.mView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    __weak typeof(self) weakself = self;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.fullScreenViewController animated:NO completion:^{
        weakself.mView.mFullScreenBtn.enabled= YES;
        weakself.mView.mFullScreenBtn.hidden = YES;
        weakself.mView.mMiniScreenBtn.hidden = NO;
        [UIView animateWithDuration:0.2f animations:^{
            weakself.mView.transform = CGAffineTransformMakeRotation(0);
        }];
    }];
}

- (void)minimizeVideo
{
    self.mView.mGetButton.hidden = YES;
    self.mView.getBtnHeightConstraint.constant = 0.f;
    self.mView.getBtnWidthConstraint.constant = 0.f;
    
    self.mView.mChangeHalfCourtButton.hidden = YES;
    self.mView.halfCourtBtnWidthConstraint.constant = 0.f;
    self.mView.halfCourtBtnHeightConstraint.constant = 0.f;
    
    self.mView.mMiniScreenBtn.enabled= NO;
    [self.superView addSubview:self.mView];
    NSDictionary *views = NSDictionaryOfVariableBindings(_mView);
    [self.superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self.superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    self.mView.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    __weak typeof(self) weakself = self;
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:NO completion:^{
        weakself.mView.mMiniScreenBtn.enabled= YES;
        weakself.mView.mMiniScreenBtn.hidden = YES;
        weakself.mView.mFullScreenBtn.hidden = NO;
        
        [UIView animateWithDuration:0.2f animations:^{
            weakself.mView.transform = CGAffineTransformMakeRotation(0);
        }];
    }];
}
-(BOOL)showChangeHalfCourtButton{
    return self.allowShowHalfCourtBtn;
}
-(BOOL)showGetButton{
    return self.allowShowGetBtn;
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
@end
