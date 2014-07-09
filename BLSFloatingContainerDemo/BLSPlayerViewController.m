//
//  BLSPlayerViewController.m
//  BLSFloatingContainer
//
//  Created by Arkadiusz Banaś on 02/07/14.
//  Copyright (c) 2014 Arkadiusz Banaś. All rights reserved.
//

#import "BLSPlayerViewController.h"
@import AVFoundation;

NSString * const didCloseNotification = @"didCloseNotification";

@interface BLSPlayerViewController ()
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, weak) IBOutlet UIImageView *equlizer;
@property (nonatomic, weak) IBOutlet UIButton *startPlayButton;


@property CGRect initializedButtonFrame;
@property CGRect initializedEqualizerFrame;
@property BOOL wasDisplayed;
@end

@implementation BLSPlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure equlizer
    NSArray *imageNames = @[@"equlizer-1", @"equlizer-2", @"equlizer-3"];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }

    self.equlizer.animationImages = images;
    self.equlizer.animationDuration = 0.5;

    // configure player
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"song" ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
    _player = newPlayer;
    [_player prepareToPlay];
    
    // I'm lazy and in demo i've choose easiest (dirty and wrong) way to scale controller in maximized state :) 
    _initializedButtonFrame = self.startPlayButton.frame;
    _initializedEqualizerFrame = self.equlizer.frame;
}

- (IBAction)playPauseButtonDidTapped:(id)sender
{
    if ([self.player isPlaying]){
        [_player pause];
        [self.equlizer stopAnimating];
        [self.startPlayButton setImage:[UIImage imageNamed:@"play-button"] forState:UIControlStateNormal];
    } else {
        [self.equlizer startAnimating];
        [self.startPlayButton setImage:[UIImage imageNamed:@"pause-button"] forState:UIControlStateNormal];
        [self.player play];
    }
}


- (BOOL)canCloseFloatingPlayerContainer:(BLSFloatingContainer *)container
{
    return YES;
}

- (void)floatingContainer:(BLSFloatingContainer *)container willMoveToPosition:(BLSFloatingContainerPosition)position
{
    NSLog(@"willMove: %@ postion: %i",container, position);
}

- (void)floatingContainer:(BLSFloatingContainer *)container didMoveToPosition:(BLSFloatingContainerPosition)position
{
    NSLog(@"didMove: %@ postion: %i",container, position);
}

- (void)floatingContainer:(BLSFloatingContainer *)container willChangeState:(BLSFloatingContainerState)state andContainerSize:(CGSize)containerSize
{
    [UIView animateWithDuration:0.25 animations:^{
        if (state == BLSFloatingContainerStateMinimized){
            self.equlizer.frame = CGRectMake(0, 0, containerSize.width, containerSize.height);
            self.startPlayButton.frame = CGRectMake(containerSize.width - 30, 0, 30, 30);
            
            self.startPlayButton.alpha = self.player.isPlaying ? 1 : 0;
            
        } else if (state == BLSFloatingContainerStateMaximized){
            self.equlizer.frame = self.initializedEqualizerFrame;
            self.startPlayButton.frame = self.initializedButtonFrame;
            
            self.startPlayButton.alpha = 1; 
        }
    }];
}

- (void)floatingContainer:(BLSFloatingContainer *)container didChangedState:(BLSFloatingContainerState)state andContainerSize:(CGSize)containerSize
{
    NSLog(@"didChangeStaet: %@ state: %i",container, state);
    
    if (state == BLSFloatingContainerStateMaximized && !self.wasDisplayed)
    {
        self.wasDisplayed = YES;
    }
    
    if (state == BLSFloatingContainerStateClosed){
        [self.player stop];
    }
}

- (void)floatingContainer:(BLSFloatingContainer *)container didPanWithCenterPoint:(CGPoint)center
{
    NSLog(@"didPanned :%@", NSStringFromCGPoint(center));
}

@end
