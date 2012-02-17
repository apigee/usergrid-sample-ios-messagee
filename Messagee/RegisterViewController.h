//
//  RegisterViewController.h
//  Messagee
//
//  Created by Ernesto Vargas on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>
#import "UGClient.h"

@interface RegisterViewController : UIViewController <RKRequestDelegate> {
        UITextField *currentTextField;
        BOOL keyboardIsShown;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *password2Field;

@end
