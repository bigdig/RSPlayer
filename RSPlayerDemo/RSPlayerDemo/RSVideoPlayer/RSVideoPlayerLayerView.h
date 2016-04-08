//
//  RSVideoPlayerLayerView.h
//  RSVideoPlayer
//
//  Created by 贾磊 on 16/1/20.
//  Copyright © 2016年 REEE INC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayer;

@interface RSVideoPlayerLayerView : UIView

@property (nonatomic, strong) AVPlayer* player;

- (void)setPlayer:(AVPlayer*)player;
- (void)setVideoFillMode:(NSString *)fillMode;

@end
