//
//  MainViewController.m
//  Bumps
//
//  Created by Matt Swanson on 4/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController
@synthesize textView, logButton, label;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	textView = [[UITextView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	textView.textColor = [UIColor whiteColor];
	textView.backgroundColor = [UIColor blackColor];
	textView.font = [UIFont fontWithName:@"Courier" size:12];
	textView.editable = FALSE;
	textView.text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.";
	self.view = textView;
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(50,200,100,100)];
	label.text = @"Log ID";
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor blackColor];
	[self.view addSubview:label];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
