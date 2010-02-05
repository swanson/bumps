//
//  stalkerAppDelegate.h
//  stalker
//
//  Created by Jevin Sweval on 2/4/10.
//  Copyright Purdue University 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class stalkerViewController;

@interface stalkerAppDelegate : NSObject <UIApplicationDelegate> {
   UIWindow *window;
   stalkerViewController *viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) stalkerViewController *viewController;

@end

