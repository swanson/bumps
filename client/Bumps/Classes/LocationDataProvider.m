//
//  LocationDataProvider.m
//  Bumps
//
//  Created by Matt Swanson on 4/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationDataProvider.h"

@implementation LocationDataProvider
@synthesize lm;
@synthesize gpsstr;
@synthesize accelstr, logid, results;


- (void) startLogging
{
	NSLog(@"startLogging()");
	lm = [[CLLocationManager alloc] init];
	lm.delegate = self; // send loc updates to myself
	[lm startUpdatingLocation];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.5];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	return;
}

- (void) stopLogging
{
	NSLog(@"stopLogging()");
	[lm stopUpdatingLocation];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:0];
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
	[lm release];
	return;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
	[gpsstr release];
	gpsstr = [[NSString alloc] initWithFormat:@"Location: %@", [newLocation description]];
	NSLog(@"%@", gpsstr);
	results.text = [NSString stringWithFormat:@"%@\n\n\n%@", gpsstr, accelstr];
	
	const char *p;
	p = [[NSString stringWithFormat:@"243:LA:%.10f\r\n", [newLocation coordinate].latitude]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"243:LO:%0.10f\r\n", [newLocation coordinate].longitude]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"243:CO:%.2f\r\n", [newLocation course]]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"243:HA:%.2f\r\n", [newLocation horizontalAccuracy]]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"243:VA:%.2f\r\n", [newLocation verticalAccuracy]]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"243:SP:%.2f\r\n", [newLocation speed]]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	[gpsstr release];
	gpsstr = [[NSString alloc] initWithFormat:@"Error: %@", [error description]];
	NSLog(@"%@", gpsstr);
	results.text = [NSString stringWithFormat:@"%@\n\n\n%@", gpsstr, accelstr];
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	[accelstr release];
	accelstr = [[NSString alloc] initWithFormat:@"Acceleration: x: %.2f y: %.2f z: %.2f ", acceleration.x, acceleration.y, acceleration.z];
	NSLog(@"%@", accelstr);
	results.text = [NSString stringWithFormat:@"%@\n\n\n%@", gpsstr, accelstr];
	
	const char *p;
	p = [[NSString stringWithFormat:@"243:AX:%.2f\r\n", acceleration.x]
         cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"243:AY:%.2f\r\n", acceleration.y]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"243:AZ:%.2f\r\n", acceleration.z]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
}

@end
