//
//  obdKey.m
//  Bumps
//
//  Created by Jevin Sweval on 4/1/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "obdKey.h"


@implementation ObdKey

@synthesize keySock;
@synthesize serverSock;

- (uint32_t)readPid:(int) pid
{
	
	return pid;
}


- (BOOL)connectSocket:(int *)sock host:(NSString *)host port:(NSString *)port
{
	int ret;
	struct addrinfo *result, hints;
	struct addrinfo *addr;
	
	int tempsock;
	
	memset(&hints, 0, sizeof hints);
	hints.ai_family = AF_INET;	// set to AF_INET to force ipv4
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = AI_PASSIVE; // use my IP
	
	ret = getaddrinfo(host, port, &hints, &result);
	assert(ret == 0);
	for(addr = result; addr != NULL; addr = addr->ai_next) {
		if ((tempsock = socket(addr->ai_family, addr->ai_socktype, addr->ai_protocol)) == -1) {
			perror("talker: socket");
			continue;
		}
		
		break;
	}
	
	if (tempsock == -1) {
		return FALSE;
	}
	
	ret = connect(tempsock, addr->ai_addr, addr->ai_addrlen);
	
	if (ret) {
		return FALSE;
	}
	*sock = tempsock;
	
	return TRUE;
}


@end
