//
//  RSVideoPlayerProtocol.h
//  RSVideoPlayer
//
//  Created by 贾磊 on 16/2/24.
//  Copyright © 2016年 REEE INC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol RSVideoPlayerProtocol <NSObject>

@property (nonatomic , assign , readonly) BOOL isPlaying;
@property (nonatomic , assign , readonly) float currentPlaybackTime;
@property (nonatomic , strong , readonly) NSString *contentURL;

@property (nonatomic , assign , readonly) BOOL showGetButton;
@property (nonatomic , assign , readonly) BOOL showChangeHalfCourtButton;

- (instancetype)initWithView:(UIView *)view;

- (void)setURL:(NSURL*)URL;
- (void)setURL:(NSURL*)URL seekToTime:(CMTime)time;

- (void)play;
- (void)pause;
- (void)stop;
- (CMTime)playerItemDuration;
- (CMTime)playerItemCurrentTime;
- (void)seekToTime:(CMTime)time;
- (void)launchFullScreen;
- (void)minimizeVideo;

- (void)beginScrubbing:(UISlider *)slider;
- (void)endScrubbing:(UISlider *)slider;
- (void)scrub:(UISlider *)slider;
- (void)showControlBar;
- (void)showControlBar:(BOOL)animated;
- (void)hideControlBar;
- (void)hideControlBar:(BOOL)animated;

- (void)changeHalfCourt;
- (void)getVideo;
@end

