//
//  SecondViewController.m
//  Messagee
//
//  Created by Ernesto Vargas on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PeopleViewController.h"

@implementation PeopleViewController
@synthesize usernameTextField;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setUsernameTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (IBAction)addPeople:(id)sender {
    // Parsing rpcData to JSON! 
        NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
    NSError *error = nil;
    NSString *json = [parser stringFromObject:rpcData error:&error];
    
    //POST json new follower blank parameters
    [[[RKClient sharedClient] post:[NSString stringWithFormat:@"users/%@/following/user/%@",
                                [[UGUser sharedInstance] username], [usernameTextField text]]
                            params:[RKRequestSerialization serializationWithData:[json dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON]
                          delegate:self] send];
}

- (void)textFieldDidBeginEditing:(UITextField *)textFieldView {
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)sender {
    [self.view removeGestureRecognizer:sender];
    [usernameTextField resignFirstResponder];
}


- (void)requestDidStartLoad:(RKRequest *)request {
    //NSLog(@"Request did start load %@", request.params);
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    //NSLog(@"Request did send body data: %@", request.HTTPBody);
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    if ((response.isOK)&&(response.isJSON)) {
        NSLog(@"json: %@", [response parsedBody:nil]);
        //TODO: Show a success message for following new user        
    } else {
        RKLogCritical(@"Loading of RKRequest %@ completed with status code %d. Response body: %@", request, response.statusCode, [response bodyAsString]);
    }
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    NSLog(@"Did Fail Load with error %@", error);
}

@end
