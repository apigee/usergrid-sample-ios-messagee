//
//  RegisterViewController.m
//  Messagee
//
//  Created by Ernesto Vargas on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"

@implementation RegisterViewController
@synthesize scrollView;
@synthesize usernameField;
@synthesize nameField;
@synthesize emailField;
@synthesize passwordField;
@synthesize password2Field;

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
    [self setUsernameField:nil];
    [self setNameField:nil];
    [self setEmailField:nil];
    [self setPasswordField:nil];
    [self setPassword2Field:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)registerButton:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [RKClient sharedClient].baseURL = [[UGClient sharedInstance] usergridApiUrl];
    
    // TODO: Validate all fields 
    if(![nameField.text isEqualToString:@""]) {
        // There's text in the box.
    }
    
    if((passwordField.text == passwordField.text)&&(![passwordField.text isEqualToString:@""])) {
        // User Params
        [params setObject:[usernameField text] forKey:@"username"];
        [params setObject:[nameField text] forKey:@"name"];
        [params setObject:[nameField text] forKey:@"email"];
        [params setObject:[passwordField text] forKey:@"password"];
        [params setObject:[password2Field text] forKey:@"password"];
        
        // Parsing rpcData to JSON! 
        id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
        NSError *error = nil;
        NSString *json = [parser stringFromObject:params error:&error];    
        
        if (!error){
            [[[RKClient sharedClient] post:@"users"
                                    params:[RKRequestSerialization serializationWithData:[json dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON]
                                  delegate:self] send];
        } 
    } else {
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"Validation Error"]
                              message:[NSString stringWithFormat:@"Passwords don't match"]
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
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
        if ([response statusCode]==200) {
            [self dismissModalViewControllerAnimated:YES];
        }
    } else if ([response statusCode]==400) {
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:[NSString stringWithFormat:@"%@", [[response parsedBody:nil] objectForKey:@"error_description"]]
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];            
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




// Keyboard stuff
- (void)viewDidLoad
{
    scrollView.frame = CGRectMake(0, 0, 320, 460);
    [scrollView setContentSize:CGSizeMake(320, 460)];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:animated];
}


- (void)textFieldDidBeginEditing:(UITextField *)textFieldView {
    currentTextField = textFieldView;
    //UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    //[self.view addGestureRecognizer:gestureRecognizer];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textFieldView {
    [textFieldView resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textFieldView {
    currentTextField = nil;
    [textFieldView resignFirstResponder];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)sender {
    //[self.view removeGestureRecognizer:sender];
}

- (void)keyboardDidShow:(NSNotification *) notification {
    if (keyboardIsShown) return;
    NSDictionary* info = [notification userInfo];
    
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    CGRect viewFrame = [scrollView frame];
    viewFrame.size.height -= keyboardRect.size.height;
    //viewFrame.size.height -= 25;
    scrollView.frame = viewFrame;
    
    CGRect textFieldRect = [currentTextField frame];
    [scrollView scrollRectToVisible:textFieldRect animated:YES];
    keyboardIsShown = YES;
}

- (void)keyboardDidHide:(NSNotification *) notification {
    NSDictionary* info = [notification userInfo];
    
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    CGRect viewFrame = [scrollView frame];
    viewFrame.size.height += keyboardRect.size.height;
    
    scrollView.frame = viewFrame;
    keyboardIsShown = NO;
}
@end
