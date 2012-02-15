//
//  UsergridController.h
//  Messagee
//
//  Created by Ernesto Vargas on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h> 
#import "UGActivitie.h"

@interface UGClient: NSObject <RKRequestDelegate> {
    NSString *usergridApiUrl;
    NSString *usergridApp;
    NSString *usergridKey;
    NSString *usergridSecret;
    
    NSString *clientCredentials;
    
    NSString *user;
    NSString *_accessToken;
    BOOL isUserLoged;
}

@property(nonatomic, strong) NSString *usergridApiUrl;
@property(nonatomic, strong) NSString *usergridApp;
@property(nonatomic, strong) NSString *usergridKey;
@property(nonatomic, strong) NSString *usergridSecret;

@property(nonatomic, strong) NSString *clientCredentials;

@property(nonatomic, strong) NSString *user;
@property(nonatomic) BOOL isUserLoged;
@property(nonatomic, strong) NSString *accessToken;

+ (UGClient *)sharedInstance;
- (void)UGClientApiUrl:(NSString *)url;
- (void)UGClientAccessToken:(NSString *)accessToken;
- (void)requestClientCredentials;

@end
