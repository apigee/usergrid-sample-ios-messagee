//
//  NewMessageViewController.h
//  Messagee
//
//  Created by Rod Simpson on 12/28/12.
//  Copyright (c) 2012 Rod Simpson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

@interface NewMessageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *messageTextField;
@property Client *clientObj;

-(void)setClient:(Client *)inclient;
- (IBAction)postMessage:(id)sender;

@end
