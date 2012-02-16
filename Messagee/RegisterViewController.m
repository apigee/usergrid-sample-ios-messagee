//
//  RegisterViewController.m
//  Messagee
//
//  Created by Ernesto Vargas on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)registerButton:(id)sender {
    // TODO: Terminate register process 
    
    //NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [RKClient sharedClient].baseURL = [[UGClient sharedInstance] usergridApiUrl];
    
    [[RKClient sharedClient] setValue:[NSString stringWithFormat:@"Bearer %@", [[UGClient sharedInstance] clientCredentials]] forHTTPHeaderField:@"Authorization"];
    
    // User Params
    [params setObject:@"test5" forKey:@"username"];
    [params setObject:@"Test" forKey:@"name"];
    [params setObject:@"a@c.com" forKey:@"email"];
    [params setObject:@"123456" forKey:@"password"];
    
    // Post message params
    //[rpcData setobject:@"test4" forKey:@"username"];
    //[rpcData setObject:@"Ernesto M" forKey:@"name"];
    //[rpcData setObject:@"a@b.com" forKey:@"email"];
    
    // Parsing rpcData to JSON! 
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
    NSError *error = nil;
    NSString *json = [parser stringFromObject:params error:&error];    
    
    if (!error){
        [[[RKClient sharedClient] post:@"users"
                                params:[RKRequestSerialization serializationWithData:[json dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON]
                              delegate:self] send];
    } 
}

- (IBAction)cancelRegisterButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)requestDidStartLoad:(RKRequest *)request {
    
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    //NSLog(@"Request did send body data");
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    if ([response isSuccessful]) {
        NSLog(@"User created");
        [self dismissModalViewControllerAnimated:YES];
        /*
        if ([[response parsedBody:nil] objectForKey:@"access_token"]) {
            //self.clientCredentials = [[response parsedBody:nil] objectForKey:@"access_token"];
        } else if ([[response parsedBody:nil] objectForKey:@"error"]) {
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:[[response parsedBody:nil] objectForKey:@"error_description"]
                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
         */
    } else if ([response isError]) {
            NSLog(@"response %@", response.bodyAsString);
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
