//
//  obdKey.h
//  Bumps
//
//  Created by Jevin Sweval on 4/1/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

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



@interface ObdKey : NSObject {
	int keySock;
	int serverSock;
   UITextView *text;
   NSString *logId;
   NSTimer *timer;
}

@property (nonatomic) int keySock;
@property (nonatomic) int serverSock;
@property (nonatomic, retain) NSString *logId;
@property (nonatomic, retain) UITextView *text;
@property (nonatomic, retain) NSTimer *timer;

- (NSString *)readPid:(int) pid len:(int)len;

- (BOOL)connectServer;
- (BOOL)connectObdKey;

- (void)initWithText:(UITextView *)text logId:(NSString *)logId;

- (BOOL)connectSocket:(int *) sock host:(NSString *)host port:(NSString *)port;

@end
