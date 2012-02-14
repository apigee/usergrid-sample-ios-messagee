//
//  FirstViewController.h
//  Messagee
//
//  Created by Ernesto Vargas on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGActivitie.h"

@interface MessageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate> {
	UITableView *_tableView;
	NSArray *_statuses;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)loadTimeline;

@end
