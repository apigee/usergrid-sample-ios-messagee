//
//  LoginViewController.m
//  Messagee
//
//  Created by Rod Simpson on 12/27/12.
//  Copyright (c) 2012 Rod Simpson. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "TabBarController.h"
#import "Client.h"



@interface LoginViewController ()

@end

@implementation LoginViewController

Client *client;

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    if ([segue.identifier isEqualToString:@"loginSeque"]){
        TabBarController *dvc = [segue destinationViewController];
        [dvc setClient:client];
    }
    
    if ([segue.identifier isEqualToString:@"registerSeque"]){
        RegisterViewController *dvc = [segue destinationViewController];
        [dvc setClient:client];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    client = [[Client alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerButton:(id)sender {
    [self performSegueWithIdentifier:@"registerSeque" sender:client];
    
}

- (IBAction)loginButton:(id)sender {

    //get the username and password from the text fields
    NSString *username = [_usernameField text];
    NSString *password = [_passwordField text];
    
    username = @"myuser";
    password = @"mypass";
    
    if ([client login:username withPassword:password]){
        [self performSegueWithIdentifier:@"loginSeque" sender:self];
    } else {
        //pop an alert saying the login failed
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed?" message:@"Did you type your username and password correctly?" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
        [alert show];
    }
    
}
@end
