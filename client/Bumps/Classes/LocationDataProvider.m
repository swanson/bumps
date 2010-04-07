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
	p = [[NSString stringWithFormat:@"%@:LA:%.10f\r\n", logid, [newLocation coordinate].latitude]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"%@:LO:%0.10f\r\n", logid, [newLocation coordinate].longitude]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"%@:CO:%.2f\r\n", logid, [newLocation course]]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"%@:HA:%.2f\r\n", logid, [newLocation horizontalAccuracy]]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"%@:VA:%.2f\r\n", logid, [newLocation verticalAccuracy]]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"%@:SP:%.2f\r\n", logid, [newLocation speed]]
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
	p = [[NSString stringWithFormat:@"%@:AX:%.2f\r\n", logid, acceleration.x]
         cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"%@:AY:%.2f\r\n", logid, acceleration.y]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
	p = [[NSString stringWithFormat:@"%@:AZ:%.2f\r\n", logid, acceleration.z]
		 cStringUsingEncoding:(NSStringEncoding)NSASCIIStringEncoding];
	//send(sockfd, p, strlen(p), 0);
}

@end
