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
@synthesize sockfd;
@synthesize addr;


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
   
   int ret;
   struct addrinfo *result;
   ret = getaddrinfo("msee140lnx10.ecn.purdue.edu", "8005", NULL, &result);
   for(addr = result; addr != NULL; addr = addr->ai_next) {
      if ((sockfd = socket(addr->ai_family, addr->ai_socktype, addr->ai_protocol)) == -1) {
         perror("talker: socket");
         continue;
      }
      
      break;
   }
   
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
   
   char *p;
   p = [[NSString stringWithFormat:@"243:4:%.10f", [newLocation coordinate].latitude]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   sendto(sockfd, p, strlen(p), 0, addr->ai_addr, addr->ai_addrlen);
   p = [[NSString stringWithFormat:@"243:5:%0.10f", [newLocation coordinate].longitude]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   sendto(sockfd, p, strlen(p), 0, addr->ai_addr, addr->ai_addrlen);
   p = [[NSString stringWithFormat:@"243:6:%.2f", [newLocation course]]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   sendto(sockfd, p, strlen(p), 0, addr->ai_addr, addr->ai_addrlen);
   p = [[NSString stringWithFormat:@"243:7:%.2f", [newLocation horizontalAccuracy]]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   sendto(sockfd, p, strlen(p), 0, addr->ai_addr, addr->ai_addrlen);
   p = [[NSString stringWithFormat:@"243:8:%.2f", [newLocation verticalAccuracy]]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   sendto(sockfd, p, strlen(p), 0, addr->ai_addr, addr->ai_addrlen);
   p = [[NSString stringWithFormat:@"243:9:%.2f", [newLocation speed]]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   sendto(sockfd, p, strlen(p), 0, addr->ai_addr, addr->ai_addrlen);
   
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
   
   char *p;
   p = [[NSString stringWithFormat:@"243:1:%.2f", acceleration.x]
         cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   sendto(sockfd, p, strlen(p), 0, addr->ai_addr, addr->ai_addrlen);
   p = [[NSString stringWithFormat:@"243:2:%.2f", acceleration.y]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   sendto(sockfd, p, strlen(p), 0, addr->ai_addr, addr->ai_addrlen);
   p = [[NSString stringWithFormat:@"243:3:%.2f", acceleration.z]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   sendto(sockfd, p, strlen(p), 0, addr->ai_addr, addr->ai_addrlen);
}

- (void)dealloc {
   [lm release];
   [textView release];
   [super dealloc];
}


@end
