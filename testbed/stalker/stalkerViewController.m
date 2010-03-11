//
//  stalkerViewController.m
//  stalker
//
//  Created by Jevin Sweval on 2/4/10.
//  Copyright 2010 Purdue University. All rights reserved.
//

#import "stalkerViewController.h"
#import <assert.h>


@implementation stalkerViewController

@synthesize textView;
@synthesize lm;
@synthesize gpsstr;
@synthesize accelstr;
@synthesize sockfd;
@synthesize addr;
@synthesize keyfd;
@synthesize key_addr;


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
   struct addrinfo *result, hints;
   
   // connect to the DB server
   memset(&hints, 0, sizeof hints);
   hints.ai_family = AF_INET; // set to AF_INET to force IPv4
   hints.ai_socktype = SOCK_STREAM;
   hints.ai_flags = AI_PASSIVE; // use my IP
   
   ret = getaddrinfo("msee140lnx10.ecn.purdue.edu", "8005", &hints, &result);
   assert(ret == 0);
   for(addr = result; addr != NULL; addr = addr->ai_next) {
      if ((sockfd = socket(addr->ai_family, addr->ai_socktype, addr->ai_protocol)) == -1) {
         perror("talker: socket");
         continue;
      }
      
      break;
   }
   
   connect(sockfd, addr->ai_addr, addr->ai_addrlen);
   
   // connect to the OBDkey
   memset(&hints, 0, sizeof hints);
   hints.ai_family = AF_INET; // set to AF_INET to force IPv4
   hints.ai_socktype = SOCK_STREAM;
   hints.ai_flags = AI_PASSIVE; // use my IP
   
   ret = getaddrinfo("192.168.0.74", "23", &hints, &result);
   assert(ret == 0);
   for(key_addr = result; key_addr != NULL; key_addr = key_addr->ai_next) {
      if ((keyfd = socket(key_addr->ai_family, key_addr->ai_socktype, key_addr->ai_protocol)) == -1) {
         perror("talker: socket");
         continue;
      }
      
      break;
   }
   
   connect(keyfd, key_addr->ai_addr, key_addr->ai_addrlen);
   
   // reset the key
   send(keyfd, "ATZ\r", strlen("ATZ\r"), 0);
   // turn echo off
   send(keyfd, "ATE0\r", strlen("ATE0\r"), 0);
   
   NSLog(@"did viewdidload");
}


- (void)read_obd {
   char c;
   char buf[512];
   char *p;
   const char *s;
   int ret;
   
   // clear the buffer
   while (recv(keyfd, &c, 1, 0) > 0);
   
   // request the throttle position
   send(keyfd, "0111\r", 5, 0);
   
   // get the response
   p = buf;
   do {
      ret = recv(keyfd, &c, 1, 0);
      if (ret <= 0)
      {
         break;
      }
      
      *(p++) = c;
   } while (c != '\r');
   *p = '\0';
   
   // change pointer to point to begining of data
   p -= 2;
   
   s = [[NSString stringWithFormat:@"243:11:%s\r\n", p]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   send(sockfd, s, strlen(s), 0);
   
   
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
   
   const char *p;
   p = [[NSString stringWithFormat:@"243:LA:%.10f\r\n", [newLocation coordinate].latitude]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   send(sockfd, p, strlen(p), 0);
   p = [[NSString stringWithFormat:@"243:LO:%0.10f\r\n", [newLocation coordinate].longitude]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   send(sockfd, p, strlen(p), 0);
   p = [[NSString stringWithFormat:@"243:CO:%.2f\r\n", [newLocation course]]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   send(sockfd, p, strlen(p), 0);
   p = [[NSString stringWithFormat:@"243:HA:%.2f\r\n", [newLocation horizontalAccuracy]]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   send(sockfd, p, strlen(p), 0);
   p = [[NSString stringWithFormat:@"243:VA:%.2f\r\n", [newLocation verticalAccuracy]]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   send(sockfd, p, strlen(p), 0);
   p = [[NSString stringWithFormat:@"243:SP:%.2f\r\n", [newLocation speed]]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   send(sockfd, p, strlen(p), 0);
   
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
   
   const char *p;
   p = [[NSString stringWithFormat:@"243:AX:%.2f\r\n", acceleration.x]
         cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   send(sockfd, p, strlen(p), 0);
   p = [[NSString stringWithFormat:@"243:AY:%.2f\r\n", acceleration.y]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   send(sockfd, p, strlen(p), 0);
   p = [[NSString stringWithFormat:@"243:AZ:%.2f\r\n", acceleration.z]
        cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
   send(sockfd, p, strlen(p), 0);
}

- (void)dealloc {
   [lm release];
   [textView release];
   [super dealloc];
}


@end
