//
//  LocationDataProvider.h
//  Bumps
//
//  Created by Matt Swanson on 4/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationDataProvider : UIViewController <UIAccelerometerDelegate,CLLocationManagerDelegate> {
	CLLocationManager *lm;
	NSString *gpsstr;
	NSString *accelstr;
	NSString *logid;
	UITextView *results;

}

@property (nonatomic, retain) CLLocationManager *lm;
@property (nonatomic, retain) NSString *gpsstr;
@property (nonatomic, retain) NSString *accelstr;
@property (nonatomic, retain) NSString *logid;
@property (nonatomic, retain) UITextView *results;;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
- (void) startLogging;
- (void) stopLogging;
@end
