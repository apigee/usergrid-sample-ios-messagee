//
//  FollowUserViewController.h
//  Messagee
//
//  Created by Rod Simpson on 12/28/12.
//  Copyright (c) 2012 Rod Simpson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

@interface FollowUserViewController : UIViewController

-(void)setClient:(Client *)inclient;
-(void)setSender:(UIViewController *)view;

- (IBAction)followButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@end
