//
//  MainViewController.m
//  Bumps
//
//  Created by Matt Swanson on 4/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController
@synthesize textView, logButton, logIDField, label, car, switch1, switch2;
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
    //fill the background with black
	UITextView * theview = [[UITextView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	theview.backgroundColor = [UIColor blackColor];
	theview.editable = FALSE;
	self.view = theview;
	[theview release];
	
    //add the textView for the value readings
	textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 120, 320, 480)];
	textView.textColor = [UIColor whiteColor];
	textView.backgroundColor = [UIColor blackColor];
	textView.font = [UIFont fontWithName:@"Courier" size:14];
	textView.editable = FALSE;
	textView.text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.";
	[self.view addSubview:textView];
	

    //add the user control labels, nothing special
   label = [[UILabel alloc] initWithFrame:CGRectMake(0,40,150,50)];
	label.text = @"OBD Enabled?";
	label.textAlignment = UITextAlignmentLeft;
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"Courier" size:16];
	[self.view addSubview:label];
	[label release];
   
   label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,70,50)];
	label.text = @"Log ID";
	label.textAlignment = UITextAlignmentLeft;
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"Courier" size:16];
	[self.view addSubview:label];
	[label release];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(0,80,150,50)];
	label.text = @"Logging Status";
	label.textAlignment = UITextAlignmentLeft;
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"Courier" size:16];
	[self.view addSubview:label];
	[label release];
	
    //create the CarDataProvider object so we can get data
   car = [CarDataProvider alloc];
   car.shouldLogOBD = FALSE;
   
   //create toggle switches, use alternateColor because we are badass like that
	switch1 = [[UISwitch alloc] initWithFrame:CGRectMake(185, 50, 500, 100)];
	[switch1 setAlternateColors:YES];   //undocumented, may cause app store rejection
	[switch1 addTarget:self action:@selector(shouldLogOBDToggled:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:switch1];
	[switch1 release];
	
   switch2 = [[UISwitch alloc] initWithFrame:CGRectMake(185, 90, 500, 100)];
	[switch2 setAlternateColors:YES]; //undocumented, may cause app store rejection
	[switch2 addTarget:self action:@selector(startLogToggled:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:switch2];
	[switch2 release];
	
    //create textfield for entering Log ID
	logIDField = [[UITextField alloc] initWithFrame:CGRectMake(80, 13, 200, 25)];
	logIDField.backgroundColor = [UIColor blackColor];
	logIDField.borderStyle = UITextBorderStyleRoundedRect;
	logIDField.delegate = self;
   logIDField.text = @"ChangeMe!";
	[self.view addSubview:logIDField];
	[logIDField release];
}

- (IBAction) shouldLogOBDToggled: (id) sender {
    //event handler for the "Do you want to log OBD data" toggle switch
   UISwitch *onoff = (UISwitch *) sender;
   if (onoff.on) {
      car.shouldLogOBD = TRUE;
   }
	else {
      car.shouldLogOBD = FALSE;
	}
   
}

- (IBAction) startLogToggled: (id) sender {
    //event handler for the "start logging" toggle switch
    UISwitch *onoff = (UISwitch *) sender;
    if (onoff.on) {
        //disable and grey-out other user controls while we are logging
       switch1.enabled = FALSE;
       logIDField.userInteractionEnabled = FALSE;
       logIDField.textColor = [UIColor grayColor];
       
       //check that we have a log ID, throw up an error popup if not
       if ([logIDField.text length] == 0)
       {
          [[[[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"Must enter Log ID!"
                                      delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil]
            autorelease] show];
          [onoff setOn:FALSE animated:TRUE];
          return;
       }
       
       //prepare the CarDataProvider
      [car initWithText:textView logId:logIDField.text];

      //try to connect to OBDKey using wifi, throw up error if this fails;
      //this will be okay if you arent logging OBD data
       if (![car connectObdKey])
       {
          [[[[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"Couldn't connect to the OBD key! =["
                                     delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil]
            autorelease] show];
          [onoff setOn:FALSE animated:TRUE];
          return;
       }
       
       //try to connect to TCP logging server using 3G, throw up error if this fails
       if (![car connectServer])
       {
          [[[[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"Couldn't connect to the central server! =["
                                      delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil]
            autorelease] show];
          [onoff setOn:FALSE animated:TRUE];
          return;
       }

        //if we made it here, we are good to go -- start logging
       [car startLogging];
   }
	else {
        //re-enable user controls when we are done logging
      switch1.enabled = TRUE;
      logIDField.userInteractionEnabled = TRUE;
      logIDField.textColor = [UIColor blackColor];

      //stop the CarDataProvider and do cleanup
      [car stopLogging];
	}

}

//black magic to make the onscreen keyboard not suck
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

//this is where you dealloc stuff, screw that -- memory leaks are fine with us!!
- (void)dealloc {
    [super dealloc];
}


@end
