//
//  Client.m
//  Messagee
//
//  Created by Rod Simpson on 12/27/12.
//  Copyright (c) 2012 Rod Simpson. All rights reserved.
//

#import "Client.h"

@implementation Client

@synthesize usergridClient, user, currentView;

- (id)init
{
    self = [super init];
    if (self) {
        
        //make new client
        usergridClient = [[UGClient alloc]initWithOrganizationId: @"/Apigee" withApplicationID:@"/MessageeApp"];
        //[usergridClient setLogging:true];
    }
    return self;
}

-(bool)login:(NSString*)username withPassword:(NSString*)password {
    
    //then log the user in
    //UGClientResponse *response =
    [usergridClient logInUser:username password:password];
    user = [usergridClient getLoggedInUser];
    
    if (user.username){
        return true;
    } else {
        return false;
    }
    
}

-(bool)createUser:(NSString*)username
         withName:(NSString*)name
        withEmail:(NSString*)email
     withPassword:(NSString*)password{

    [usergridClient addUser:username email:email name:name password:password];
    
    return [self login:username withPassword:password];
}

-(NSArray*)getFollowing {
        
    UGQuery *query = [[UGQuery alloc] init];
    [query addURLTerm:@"limit" equals:@"30"];
    UGClientResponse *response = [usergridClient getEntityConnections: @"users" connectorID:@"me" connectionType:@"following" query:query];

    NSArray * followers = [response.response objectForKey:@"entities"];

    return followers;
    
}

-(bool)followUser:(NSString*)username{
    
    UGClientResponse *response = [usergridClient connectEntities:@"users"
                                                connectorID:@"me"
                                                connectionType:@"following"
                                                connecteeType:@"users"
                                                connecteeID:username];
    
    if (response.transactionState == 0) {
        return true;
    }
    return false;
    
}


-(NSArray*)getMessages {
    
    NSString *username = [user username];
    
    UGQuery *query = [[UGQuery alloc] init];
    [query addURLTerm:@"limit" equals:@"30"];
    UGClientResponse *response = [usergridClient getActivitiesForUser:username query:query];
    
    NSArray *messages = [response.response objectForKey:@"entities"];

    return messages;
    
}

-(bool)postMessage:(NSString*)message {
    
    /*
     //we are trying to build a json object that looks like this:
     {
        "actor" : {
            "displayName" :"myusername",
            "uuid" : "myuserid",
            "username" : "myusername",
            "email" : "myemail",
            "picture": "http://path/to/picture",
            "image" : {
                "duration" : 0,
                "height" : 80,
                "url" : "http://www.gravatar.com/avatar/",
                "width" : 80
            },
        },
        "verb" : "post",
        "content" : content,
        "lat" : 48.856614,
        "lon" : 2.352222
     }
     */
    
    NSMutableDictionary *activity = [[NSMutableDictionary alloc] init ];
    NSMutableDictionary *actor = [[NSMutableDictionary alloc] init];
    
    NSString *username = [user username];
    NSString *email = [user email];
    NSString *uuid = [user uuid];
    NSString *picture = [user picture];
    NSString *lat = @"48.856614";
    NSString *lon = @"2.352222f";
    
    // actor
    [actor setObject:username forKey:@"displayName"];
    [actor setObject:uuid forKey:@"uuid"];
    [actor setObject:username forKey:@"username"];
    [actor setObject:email forKey:@"email"];
    [actor setObject:picture forKey:@"picture"];

    // activity 
    [activity setValue:actor forKey:@"actor"];
    [activity setObject:@"post" forKey:@"verb"];
    [activity setObject:message forKey:@"content"];
    [activity setObject:lat forKey:@"lat"];
    [activity setObject:lon forKey:@"lon"];

    UGClientResponse *response = [usergridClient postUserActivity:uuid activity:activity];
    
    if (response.transactionState == 0) {
        return true;
    }
    return false;
}



/*
 //and then send the user to the location section
 UIViewController *locationController = [[LocationViewController alloc] initWithGameState: gstate];
 //self.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
 [self presentViewController:locationController animated:YES completion:nil];
 */















@end
