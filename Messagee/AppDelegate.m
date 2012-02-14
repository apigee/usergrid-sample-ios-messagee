//
//  AppDelegate.m
//  Messagee
//
//  Created by Ernesto Vargas on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/RestKit.h>

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Usergrid Settings
    [[UGClient sharedInstance] setUsergridApiUrl:@"http://apigee-test.usergrid.com"];
    [[UGClient sharedInstance] setUsergridApp:@"Messagee"];
    [[UGClient sharedInstance] setUsergridKey:@"b3U6C-K7vkw9EeG0HSIAChxOIg"];
    [[UGClient sharedInstance] setUsergridSecret:@"b3U6Qxux-D4mO8uaTrSrjpEbikgshvk"];
    
    RKClient *client = [RKClient clientWithBaseURL:[[UGClient sharedInstance] usergridApiUrl]];
    [RKClient setSharedClient:client];
    
    // Load the object model via RestKit	
    RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:[[UGClient sharedInstance] usergridApiUrl]];
    
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[UGActivitie class]];
    [userMapping mapKeyPath:@"content" toAttribute:@"content"];
    [userMapping mapKeyPath:@"type" toAttribute:@"type"];
    
    [objectManager.mappingProvider setMapping:userMapping forKeyPath:@"entities"];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
