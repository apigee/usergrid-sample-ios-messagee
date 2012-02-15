//
//  UGUser.m
//  Messagee
//
//  Created by Ernesto Vargas on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UGUser.h"

@implementation UGUser

@synthesize username = _username;
@synthesize email = _email;
@synthesize picture = _picture;

+ (UGUser *)sharedInstance
{
    static UGUser *myInstance = nil;
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
    }
    return myInstance;
}

@end
