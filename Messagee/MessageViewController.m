//
//  FirstViewController.m
//  Messagee
//
//  Created by Ernesto Vargas on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageViewController.h"
#import "UGClient.h"

@implementation MessageViewController
@synthesize scrollView = _scrollView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadMessageBoard {
    // Message Maping
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[UGActivitie class]];
    [userMapping mapKeyPath:@"content" toAttribute:@"content"];
    [userMapping mapKeyPath:@"type" toAttribute:@"type"];    
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@"entities"];

    // Request user feed
    // TODO:Change the app name and user from UGclient
    [[RKObjectManager sharedManager] 
     loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@/user/netoxico/feed?limit=20",
                                [[UGClient sharedInstance] usergridApp]]
     delegate:self];
}


- (void)viewDidLoad
{
    // When view did load, create table and load message board
    [super viewDidLoad];
    
    self.scrollView.frame = CGRectMake(0, 0, 320, 460);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, 320, 480-64) style:UITableViewStylePlain];
	_tableView.dataSource = self;
	_tableView.delegate = self;		
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.scrollView addSubview:_tableView];
    [self loadMessageBoard];
    
    // Load message board every 5 seconds 
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadMessageBoard) userInfo:NULL repeats:YES];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
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

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    //NSLog(@"* Did load response: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    [self.scrollView setContentSize:CGSizeMake(320, [_tableView contentSize].height)];
    _statuses = objects;
    [_tableView reloadData];

}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	NSLog(@"**Object loader did fail with Error: %@", error);
}



#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGSize size = [[[_statuses objectAtIndex:indexPath.row] content] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 9000)];
	return size.height + 10;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return [_statuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* reuseIdentifier = @"Cell Identifier";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (nil == cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        cell.textLabel.textColor = [UIColor whiteColor];
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.backgroundColor = [UIColor clearColor];
		//cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg.png"]];
	}
	cell.textLabel.text = [[_statuses objectAtIndex:indexPath.row] content];
	return cell;
}

@end
