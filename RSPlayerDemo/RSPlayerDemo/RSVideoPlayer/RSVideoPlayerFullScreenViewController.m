//
//  RSVideoPlayerFullScreenViewController.m
//  RSVideoPlayer
//
//  Created by 贾磊 on 16/2/15.
//  Copyright © 2016年 REEE INC. All rights reserved.
//

#import "RSVideoPlayerFullScreenViewController.h"
#import "RSVideoPlayerFullScreenView.h"

@interface RSVideoPlayerFullScreenViewController ()
@property (nonatomic, strong) RSVideoPlayerFullScreenView *fullScreenView;
@end

@implementation RSVideoPlayerFullScreenViewController

- (id)init
{
    if (self = [super init]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    return self;
}

- (void)loadView
{
    self.fullScreenView = [[RSVideoPlayerFullScreenView alloc] init];
    [self setView:self.fullScreenView];
}

- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
