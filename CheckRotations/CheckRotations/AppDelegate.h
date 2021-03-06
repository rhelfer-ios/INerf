//
//  AppDelegate.h
//  CheckRotations
//
//  Created by Ran Halfer on 30/04/2017.
//  Copyright © 2017 Ran Helfer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotationsChecker.h"
#import <CoreMotion/CoreMotion.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RotationsChecker *rotationsController;
@property (strong, nonatomic, readonly) CMMotionManager *sharedManager;

@end

