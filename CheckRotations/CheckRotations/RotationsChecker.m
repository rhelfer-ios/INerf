//
//  RotationsChecker.m
//  CheckRotations
//
//  Created by Ran Halfer on 30/04/2017.
//  Copyright © 2017 Ran Helfer. All rights reserved.
//

#import "RotationsChecker.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

static const NSTimeInterval deviceMotionMin = 0.01;

@interface RotationsChecker ()
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimer *threatTimer;
@property (strong, nonatomic)  AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *dragonImage;
@end

@implementation RotationsChecker

- (void)viewDidLoad {
    [super viewDidLoad];

    CMMotionManager *mManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    NSTimeInterval delta = 0.005;
    NSTimeInterval updateInterval = deviceMotionMin + delta;
    
    if ([mManager isDeviceMotionAvailable] == YES) {
        [mManager setDeviceMotionUpdateInterval:updateInterval];
        [mManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *deviceMotion, NSError *error) {
          
                if(fabs(deviceMotion.gravity.x) < 0.95 || fabs(deviceMotion.attitude.roll) > 1.6) {
                    [self setTimer];
                }
                else {
                    [self setThreatTimer];
                }
        }];
    }
}

- (void)setThreatTimer {
    
    if(_threatTimer || _timer) {
        return;
    }
    
    _threatTimer = [NSTimer scheduledTimerWithTimeInterval:15.0
                                              target:self
                                            selector:@selector(playDragonThreat)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)setTimer {
    
    if(_timer != nil) {
        return;
    }
    
    [self.threatTimer invalidate];
    self.threatTimer = nil;
    
    [self playPain];

    // Some small inimation
    CGPoint centerKeeper = self.dragonImage.center;
    [UIView animateWithDuration:3.0 animations:^{
        self.dragonImage.center = CGPointMake(-400, centerKeeper.y);
        self.dragonImage.alpha = 0.3;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:3.0 animations:^{
            self.dragonImage.center = centerKeeper;
            self.dragonImage.alpha = 1.0;
        }];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                      target:self
                                                    selector:@selector(cancelTimer)
                                                    userInfo:nil
                                                     repeats:NO];
}

- (void)cancelTimer {
    
    [_timer invalidate];
    _timer = nil;
    
    [_threatTimer invalidate];
    _threatTimer = nil;
}

- (void)playPain {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"pain" ofType: @"m4a"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath ];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        self.audioPlayer.numberOfLoops = 0; 
        [self.audioPlayer play];
        
    });
}

- (void)playDragonThreat {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Threat" ofType: @"m4a"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath ];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        self.audioPlayer.numberOfLoops = 0;
        [self.audioPlayer play];
        
    });
}

@end
