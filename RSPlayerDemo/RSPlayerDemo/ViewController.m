//
//  ViewController.m
//  RSPlayerDemo
//
//  Created by 贾磊 on 16/4/7.
//  Copyright © 2016年 devjia. All rights reserved.
//


//http://qiniu.reee.cn/m3u8/160407/CG00030/CA00061_160407143000/fda33ba6e70949f5b9e33886ddee2625.m3u8
//http://qiniu.reee.cn/m3u8/160407/CG00030/CA00062_160407143000/9c10edad86964894ac759d1561ae4fa6.m3u8
//http://qiniu.reee.cn/m3u8/160407/CG00030/CA00063_160407143001/58e126e4da3548e0b5d76dadf6367c99.m3u8
//http://qiniu.reee.cn/m3u8/160407/CG00030/CA00064_160407143000/53da295bdcf4417b9337315ea3feb68a.m3u8

#import "ViewController.h"
#import "RSVideoPlayer.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RSVideoPlayerLoadingView.h"

@interface ViewController ()<RSVideoPlayerDelegate>

@property (nonatomic,strong) RSVideoPlayer *player;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.player = [[RSVideoPlayer alloc] initWithView:self.backgroundView];
    self.player.delegate = self;

    
}

- (void)videoPlayer:(RSVideoPlayer *)player recordURL:(NSURL *)URL playBackTime:(CGFloat)playBackTime{
    NSLog(@"URL=%@",URL);
    NSLog(@"playBackTime = %f",playBackTime);
}

- (IBAction)stop:(UIButton *)sender {
    
    [self.player stop];
}

- (IBAction)play:(UIButton *)sender {
    
    NSUInteger tag = sender.tag-1000;
    switch (tag) {
        case 1:
        {
                [self.player setURL:[NSURL URLWithString:@"http://qiniu.reee.cn/m3u8/160407/CG00030/CA00061_160407143000/fda33ba6e70949f5b9e33886ddee2625.m3u8"]];
        }
            break;
        case 2:
        {
                [self.player setURL:[NSURL URLWithString:@"http://qiniu.reee.cn/m3u8/160407/CG00030/CA00062_160407143000/9c10edad86964894ac759d1561ae4fa6.m3u8"]];
        }
            break;
        case 3:
        {
                [self.player setURL:[NSURL URLWithString:@"http://qiniu.reee.cn/m3u8/160407/CG00030/CA00063_160407143001/58e126e4da3548e0b5d76dadf6367c99.m3u8"]];
        }
            break;
        case 4:
        {
                [self.player setURL:[NSURL URLWithString:@"ahttp://qiniu.reee.cn/m3u8/160407/CG00030/CA00064_160407143000/53da295bdcf4417b9337315ea3feb68a.m3u8"]];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
