//
//  LoginViewController.h
//  Messagee
//
//  Created by Rod Simpson on 12/27/12.
//  Copyright (c) 2012 Rod Simpson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


- (IBAction)registerButton:(id)sender;
- (IBAction)loginButton:(id)sender;

@end
