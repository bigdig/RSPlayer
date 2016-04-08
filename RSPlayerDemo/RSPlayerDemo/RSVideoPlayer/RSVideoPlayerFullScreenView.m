//
//  RSVideoPlayerFullScreenView.m
//  RSVideoPlayer
//
//  Created by 贾磊 on 16/2/15.
//  Copyright © 2016年 REEE INC. All rights reserved.
//

#import "RSVideoPlayerFullScreenView.h"

@implementation RSVideoPlayerFullScreenView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.autoresizesSubviews = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
@end
