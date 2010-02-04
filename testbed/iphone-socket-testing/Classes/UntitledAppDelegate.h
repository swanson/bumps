//
//  UntitledAppDelegate.h
//  Untitled
//
//  Created by Matt Swanson on 2/4/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UntitledViewController;

@interface UntitledAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UntitledViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UntitledViewController *viewController;

@end

