//
//  NewMessageViewController.m
//  Messagee
//
//  Created by Ernesto Vargas on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewMessageViewController.h"

@implementation NewMessageViewController
@synthesize messageTextField;


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

- (void)viewWillAppear:(BOOL)flag {
    [super viewWillAppear:flag];
    [messageTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setMessageTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (IBAction)postMessage:(id)sender {
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    // User Params
    [params setObject:[[UGUser sharedInstance] username] forKey:@"displayName"];
    [params setObject:[[UGUser sharedInstance] email] forKey:@"email"];
    [params setObject:[[UGUser sharedInstance] picture] forKey:@"picture"];
    
    // Post message params
    [rpcData setValue:params forKey:@"actor"];
    [rpcData setObject:@"post" forKey:@"verb"];
    [rpcData setObject:[messageTextField text] forKey:@"content"];
    
    // Parsing rpcData to JSON! 
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
    NSError *error = nil;
    NSString *json = [parser stringFromObject:rpcData error:&error];    
    
    if (!error){
        // POST json message to: /user/<username>/activities/
        [[[RKClient sharedClient] post:[NSString stringWithFormat:@"user/%@/activities/", [[UGUser sharedInstance] username]]
                 params:[RKRequestSerialization serializationWithData:[json dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON]
               delegate:self] send];
    }
}

- (IBAction)closeMessage:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)requestDidStartLoad:(RKRequest *)request {
    NSLog(@"Request did start load %@", request.params);
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    NSLog(@"Request did send body data: %@", request.HTTPBody);
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    if ((response.isOK)&&(response.isJSON)) {
        NSLog(@"json: %@", [response parsedBody:nil]);
        [self dismissModalViewControllerAnimated:YES];
    } else {
        RKLogCritical(@"Loading of RKRequest %@ completed with status code %d. Response body: %@", request, response.statusCode, [response bodyAsString]);
    }
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    NSLog(@"Did Fail Load with error %@", error);
}

@end
