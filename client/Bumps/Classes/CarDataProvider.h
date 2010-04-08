//
//  CarDataProvider.h
//  Bumps
//
//  Created by Jevin Sweval on 4/1/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import <stdint.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <fcntl.h>

#import "config.h"



@interface CarDataProvider : UIViewController <UIAccelerometerDelegate,CLLocationManagerDelegate> {
	int keySock;
	int serverSock;
   UITextView *text;
   NSString *logId;
   NSTimer *timer;
	CLLocationManager *lm;
	NSString *obdDisplayStr;
	NSString *gpsDisplayStr;
	NSString *accelDisplayStr;
}

@property (nonatomic) int keySock;
@property (nonatomic) int serverSock;
@property (nonatomic, retain) NSString *logId;
@property (nonatomic, retain) UITextView *text;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) CLLocationManager *lm;
@property (nonatomic, retain) NSString *obdDisplayStr;
@property (nonatomic, retain) NSString *gpsDisplayStr;
@property (nonatomic, retain) NSString *accelDisplayStr;

- (NSString *)readPid:(int) pid len:(int)len;

- (BOOL)connectServer;
- (BOOL)connectObdKey;

- (void)startLogging;
- (void)stopLogging;

- (void)updateDisplay;

- (void)initWithText:(UITextView *)text logId:(NSString *)logId;

- (BOOL)connectSocket:(int *) sock host:(NSString *)host port:(NSString *)port;

@end
