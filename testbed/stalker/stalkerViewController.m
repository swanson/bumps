//
//  stalkerViewController.m
//  stalker
//
//  Created by Jevin Sweval on 2/4/10.
//  Copyright 2010 Purdue University. All rights reserved.
//

#import "stalkerViewController.h"


@implementation stalkerViewController

@synthesize textView;
@synthesize lm;
@synthesize gpsstr;
@synthesize accelstr;


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
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
   gpsstr = [[NSString alloc] initWithString:@"n/a"];
   accelstr = [[NSString alloc] initWithString:@"n/a"];
   lm = [[CLLocationManager alloc] init];
   lm.delegate = self; // send loc updates to myself
   [lm startUpdatingLocation];
   [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.1];
   [[UIAccelerometer sharedAccelerometer] setDelegate:self];
   NSLog(@"did viewdidload");
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

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
   [gpsstr release];
   gpsstr = [[NSString alloc] initWithFormat:@"Location: %@", [newLocation description]];
   NSLog(@"%@", gpsstr);
   textView.text = [NSString stringWithFormat:@"%@\n\n\n%@", gpsstr, accelstr];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
   [gpsstr release];
   gpsstr = [[NSString alloc] initWithFormat:@"Error: %@", [error description]];
	NSLog(@"%@", gpsstr);
   textView.text = [NSString stringWithFormat:@"%@\n\n\n%@", gpsstr, accelstr];
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
   [accelstr release];
   accelstr = [[NSString alloc] initWithFormat:@"Acceleration: x: %.2f y: %.2f z: %.2f ", acceleration.x, acceleration.y, acceleration.z];
   NSLog(@"%@", accelstr);
   textView.text = [NSString stringWithFormat:@"%@\n\n\n%@", gpsstr, accelstr];
}

- (void)dealloc {
   [lm release];
   [textView release];
   [super dealloc];
}


@end
