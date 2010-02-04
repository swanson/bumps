//
//  UntitledViewController.m
//  Untitled
//
//  Created by Matt Swanson on 2/4/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "UntitledViewController.h"
#import "AsyncSocket.h"
@implementation UntitledViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	NSLog(@"loadview");
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"init");
	
	if(self = [super init])
	{
		asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
	}

	NSLog(@"Ready");
	
	NSError *err = nil;
	//connect to localhost socket server (python)
	if(![asyncSocket connectToHost:@"127.0.0.1" onPort:50001 error:&err])
	{
		NSLog(@"Error: %@", err);
	}
	NSString *message = @"hello from the iphone";
	NSString *terminatedMessage = [message stringByAppendingString:@"\r\n"];
    NSData *terminatedMessageData = [terminatedMessage dataUsingEncoding:NSASCIIStringEncoding];
	//[asyncSocket writeData:@"test"];
	[asyncSocket writeData:terminatedMessageData withTimeout:10 tag:0];
	
}

- (void)onSocketDidSecure:(AsyncSocket *)sock
{
	NSLog(@"onSocketDidSecure:%p", sock);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	NSLog(@"onSocket:%p willDisconnectWithError:%@", sock, err);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	NSLog(@"onSocketDidDisconnect:%p", sock);
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
