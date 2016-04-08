//
//  RSVideoPlayerView.h
//  RSVideoPlayer
//
//  Created by 贾磊 on 16/1/20.
//  Copyright © 2016年 REEE INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSVideoPlayerLayerView.h"
#import "RSVideoPlayerForwardReverseView.h"
#import "RSVideoPlayerLoadingView.h"
#import "RSVideoPlayerProtocol.h"

typedef enum : NSUInteger {
    PlayerPanEventTypeNone,
    PlayerPanEventTypeVolume,
    PlayerPanEventTypeBrightness,
    PlayerPanEventTypeForward
} PlayerPanEventType;

@interface RSVideoPlayerView : UIView

@property (nonatomic , strong ) UIImageView                     *mBackgroundImageView;//底部覆盖层
@property (nonatomic , strong ) RSVideoPlayerLayerView          *mPlaybackView;//显示层视图
@property (nonatomic , strong ) UIView                          *mControlBar;
@property (nonatomic , strong ) UIButton                        *mPlayButton;
@property (nonatomic , strong ) UIButton                        *mPauseButton;
@property (nonatomic , strong ) UIButton                        *mFullScreenBtn;
@property (nonatomic , strong ) UIButton                        *mMiniScreenBtn;
@property (nonatomic , strong ) UIButton                        *mChangeHalfCourtButton;
@property (nonatomic , strong ) UIButton                        *mGetButton;
//@property (nonatomic , strong ) UIProgressView                  *mLoadProgressView;
@property (nonatomic , strong ) UISlider                        *mScrubber;
@property (nonatomic , strong ) UILabel                         *mPlayTimeLabel;
@property (nonatomic , strong ) UILabel                         *mTotalTimeLabel;
@property (nonatomic , assign ) id<RSVideoPlayerProtocol                    > delegate;


@property (nonatomic , assign) CGPoint originPoint;
@property (nonatomic , strong) NSMutableArray *panPoints;
@property (nonatomic , assign) PlayerPanEventType panEventType;

@property (nonatomic , strong) NSLayoutConstraint *halfCourtBtnWidthConstraint;
@property (nonatomic , strong) NSLayoutConstraint *halfCourtBtnHeightConstraint;
@property (nonatomic , strong) NSLayoutConstraint *getBtnWidthConstraint;
@property (nonatomic , strong) NSLayoutConstraint *getBtnHeightConstraint;
@end
