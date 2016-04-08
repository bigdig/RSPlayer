//
//  RSVideoPlayer.h
//  RSVideoPlayer
//
//  Created by 贾磊 on 16/1/20.
//  Copyright © 2016年 REEE INC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RSVideoPlayerView.h"
#import "RSVideoPlayerLayerView.h"
#import "RSVideoPlayerFullScreenViewController.h"
#import "RSVideoPlayerProtocol.h"
#import "RSVideoPlayerLoadingView.h"
#import "RSVideoPlayerForwardReverseView.h"

static void *AVPlayerObservationContext = &AVPlayerObservationContext;
static void *AVPlayerItemObservationContext = &AVPlayerItemObservationContext;

//todo 完善player各状态切换
typedef enum : NSUInteger {
    RSVideoPlayerStateUnknown,
    RSVideoPlayerStatePrepareToPlay,
    RSVideoPlayerStateLoading,
    RSVideoPlayerStatePlaying,
    RSVideoPlayerStatePause,
    RSVideoPlayerStateStop,
    RSVideoPlayerStateError
} RSVideoPlayerState;

@protocol RSVideoPlayerDelegate;
@interface RSVideoPlayer : NSObject<RSVideoPlayerProtocol>

@property (nonatomic , strong ) NSURL                                 *mURL;
@property (nonatomic , strong ) AVPlayer                              *mPlayer;
@property (nonatomic , strong ) AVPlayerItem                          *mPlayerItem;
@property (nonatomic , strong ) id                                    mTimeObserver;
@property (nonatomic , strong ) RSVideoPlayerView                     *mView;//UI视图
@property (nonatomic , strong ) UIView                                *superView;//父视图
@property (nonatomic , strong ) RSVideoPlayerFullScreenViewController *fullScreenViewController;//全屏视图

@property (nonatomic , assign ) RSVideoPlayerState                    state;
@property (nonatomic , assign ) BOOL                                  seekToTimeBeforePlay;
@property (nonatomic , assign ) BOOL                                  isSeeking;
@property (nonatomic , assign ) BOOL                                  isScrubbing;
@property (nonatomic , assign ) BOOL                                  isFullScreen;
@property (nonatomic , assign ) BOOL                                  isUserPause;
@property (nonatomic , assign ) CGFloat                               lastScrubTime;
@property (nonatomic , assign ) CMTime                                seekTime;
@property (nonatomic , assign ) BOOL                                  allowShowHalfCourtBtn;
@property (nonatomic , assign ) BOOL                                  allowShowGetBtn;
@property (nonatomic , assign ) id<RSVideoPlayerDelegate                > delegate;

@property (nonatomic , strong) NSString *videoId;
@property (nonatomic , strong) NSString *videoType;
@property (nonatomic , strong) NSString *matchId;
@end


@protocol RSVideoPlayerDelegate <NSObject>

@optional
-(void) changeHalfCourt;
-(void) getVideo;
- (void)videoPlayer:(RSVideoPlayer *)player recordURL:(NSURL *)URL playBackTime:(CGFloat)playBackTime;
@end
