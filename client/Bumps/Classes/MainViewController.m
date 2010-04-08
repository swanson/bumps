//
//  MainViewController.m
//  Bumps
//
//  Created by Matt Swanson on 4/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController
@synthesize textView, logButton, logIDField, label, car;
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
	UITextView * theview = [[UITextView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	theview.backgroundColor = [UIColor blackColor];
	theview.editable = FALSE;
	self.view = theview;
	[theview release];
	
	textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, 320, 480)];
	textView.textColor = [UIColor whiteColor];
	textView.backgroundColor = [UIColor blackColor];
	textView.font = [UIFont fontWithName:@"Courier" size:14];
	textView.editable = FALSE;
	textView.text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.";
	[self.view addSubview:textView];
	
   label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,70,50)];
	label.text = @"Log ID";
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor blackColor];
	label.font = [UIFont fontWithName:@"Courier" size:16];
	[self.view addSubview:label];
	[label release];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(0,40,70,50)];
	label.text = @"Status";
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor blackColor];
	label.font = [UIFont fontWithName:@"Courier" size:16];
	[self.view addSubview:label];
	[label release];
	
   car = [CarDataProvider alloc];
   
	UISwitch *logSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(80, 50, 500, 100)];
	[logSwitch setAlternateColors:YES];
	[logSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:logSwitch];
	[logSwitch release];
	
	
	logIDField = [[UITextField alloc] initWithFrame:CGRectMake(80, 13, 200, 25)];
	logIDField.backgroundColor = [UIColor blackColor];
	logIDField.borderStyle = UITextBorderStyleRoundedRect;
	logIDField.delegate = self;
   logIDField.text = @"ChangeMe!";
	[self.view addSubview:logIDField];
	[logIDField release];
}

- (IBAction) switchToggled: (id) sender {
    UISwitch *onoff = (UISwitch *) sender;
    if (onoff.on) {
       if ([logIDField.text length] == 0)
       {
          [[[[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"Must enter Log ID!"
                                      delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil]
            autorelease] show];
          [onoff setOn:FALSE animated:TRUE];
          return;
       }
       
      [car initWithText:textView logId:logIDField.text];

       if (![car connectObdKey])
       {
          [[[[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"Couldn't connect to the OBD key! =["
                                     delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil]
            autorelease] show];
          [onoff setOn:FALSE animated:TRUE];
          return;
       }
       
       if (![car connectServer])
       {
          [[[[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"Couldn't connect to the central server! =["
                                      delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil]
            autorelease] show];
          [onoff setOn:FALSE animated:TRUE];
          return;
       }
       
       [car startLogging];
   }
	else {
      [car stopLogging];
	}

}

- (BOOL)textFieldShouldReturn:(UITextField *)logIDField_foo {
	[logIDField_foo resignFirstResponder];
	return YES;
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
