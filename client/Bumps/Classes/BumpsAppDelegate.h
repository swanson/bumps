#import <UIKit/UIKit.h>

@class MainViewController;

@interface BumpsAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	MainViewController *viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MainViewController *viewController;

@end