//
//  FirstViewController.h
//  Messagee
//
//  Created by Ernesto Vargas on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UGActivitie.h"
#import "UGClient.h"
#import "UGUser.h"
#import "UGActor.h"

@interface MessageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate> {
	UITableView *_tableView;
	NSArray *_statuses;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
