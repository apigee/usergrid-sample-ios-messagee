//
//  LoginViewController.h
//  Messagee
//
//  Created by Ernesto Vargas on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h> 
#import "UGUser.h"

@interface LoginViewController : UIViewController <RKRequestDelegate, RKObjectLoaderDelegate> {
    UITextField *currentTextField;
    UIButton *loginButton;
    BOOL keyboardIsShown;
    NSArray* _access;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
