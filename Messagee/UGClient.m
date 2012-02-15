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

@synthesize clientCredentials = _clientCredentials;

@synthesize user = _user;
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

- (void)UGClientApiUrl:(NSString *)url {
    // Set base Urls
    self.usergridApiUrl = url;
    RKClient *client = [RKClient clientWithBaseURL:url];
    [RKClient setSharedClient:client];
    [RKObjectManager objectManagerWithBaseURL:url];
    [RKObjectManager sharedManager].client.baseURL = url;
}

- (void)UGClientAccessToken:(NSString *)accessToken {
    //Sets RKClient and RKObjectManager access token Authorization HTTP header
    self.accessToken = accessToken;
    [[RKClient sharedClient] setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [[RKObjectManager sharedManager].client setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
}

- (void)requestClientCredentials {
    [RKClient sharedClient].baseURL = [self usergridApiUrl];
    [[RKClient sharedClient]
     get:[NSString stringWithFormat:@"%@/token?grant_type=client_credentials&client_id=%@&client_secret=%@",
          self.usergridApp, self.usergridKey, self.usergridSecret]
     delegate:self];
}

- (void)requestDidStartLoad:(RKRequest *)request {
    //NSLog(@"Request start load %@", request.params);
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    //NSLog(@"Request did send body data");
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    if ([response isSuccessful]) {
        if ([[response parsedBody:nil] objectForKey:@"access_token"]) {
            self.clientCredentials = [[response parsedBody:nil] objectForKey:@"access_token"];
        } else if ([[response parsedBody:nil] objectForKey:@"error"]) {
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:[[response parsedBody:nil] objectForKey:@"error_description"]
                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([response isError]) {
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:[NSString stringWithFormat:@"Status code: %d", response.statusCode]
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    NSLog(@"Did Fail Load with error %@", error);
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:[NSString stringWithFormat:@"Error %d", error.code]
                          message:[NSString stringWithFormat:@"%@", error]
                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
