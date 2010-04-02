#import "BumpsAppDelegate.h"
#import "MainViewController.h"

@implementation BumpsAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	// Override point for customization after app launch
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	viewController = [[MainViewController alloc] init];
	
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];
}


- (void)dealloc {
	[viewController release];
	[window release];
	[super dealloc];
}


@end

