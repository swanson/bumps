//
//  stalkerViewController.h
//  stalker
//
//  Created by Jevin Sweval on 2/4/10.
//  Copyright 2010 Purdue University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>


@interface stalkerViewController : UIViewController <UITextViewDelegate,UIAccelerometerDelegate,CLLocationManagerDelegate> {
	UITextView *textView;
   CLLocationManager *lm;
   NSString *gpsstr;
   NSString *accelstr;
   int sockfd;
   struct addrinfo *addr;
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) CLLocationManager *lm;
@property (nonatomic, retain) NSString *gpsstr;
@property (nonatomic, retain) NSString *accelstr;
@property (nonatomic) int sockfd;
@property (nonatomic) struct addrinfo *addr;

- (void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;


@end
