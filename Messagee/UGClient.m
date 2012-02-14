//
//  UsergridController.m
//  Messagee
//
//  Created by Ernesto Vargas on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UGClient.h"
#import "LoginViewController.h"

@implementation UGClient

@synthesize usergridApiUrl = _usergridApiUrl;
@synthesize usergridApp = _usergridApp;
@synthesize usergridKey = _usergridKey;
@synthesize usergridSecret = _usergridSecret;

@synthesize isUserLoged;
@synthesize accessToken = _accesssToken;

+ (UGClient *)sharedInstance
{
    static UGClient *myInstance = nil;
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
    }
    return myInstance;
}

@end
