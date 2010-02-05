//
//  stalkerAppDelegate.m
//  stalker
//
//  Created by Jevin Sweval on 2/4/10.
//  Copyright Purdue University 2010. All rights reserved.
//

#import "stalkerAppDelegate.h"
#import "stalkerViewController.h"

@implementation stalkerAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
   
   // Override point for customization after app launch
   window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
   viewController = [[stalkerViewController alloc] init];

   [window addSubview:viewController.view];
   [window makeKeyAndVisible];
}


- (void)dealloc {
   [viewController release];
   [window release];
   [super dealloc];
}


@end
