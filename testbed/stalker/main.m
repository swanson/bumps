//
//  main.m
//  stalker
//
//  Created by Jevin Sweval on 2/4/10.
//  Copyright Purdue University 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"stalkerAppDelegate");
    [pool release];
    return retVal;
}
