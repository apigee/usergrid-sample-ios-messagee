//
//  FirstViewController.m
//  Messagee
//
//  Created by Ernesto Vargas on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageViewController.h"


@interface UIImage (TPAdditions)
- (UIImage*)imageScaledToSize:(CGSize)size;
@end

@implementation UIImage (TPAdditions)
- (UIImage*)imageScaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation MessageViewController
@synthesize scrollView = _scrollView;

NSTimer *timer;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadMessageBoard {
    // Request user feed
    // GET feed from users/<username>/feed?limit=30
    [[RKObjectManager sharedManager]
     loadObjectsAtResourcePath:[NSString stringWithFormat:@"user/%@/feed?limit=30",
                                [[UGUser sharedInstance] username]]
     delegate:self];
}


- (void)viewDidLoad
{
    // When view did load, Map message, create table and load message board
    [super viewDidLoad];
    
    self.scrollView.frame = CGRectMake(0, 0, 320, 460);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, 480-64) style:UITableViewStylePlain];
	_tableView.dataSource = self;
	_tableView.delegate = self;		
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.scrollView addSubview:_tableView];

    // Message Mapping
    RKObjectMapping* actorMapping = [RKObjectMapping mappingForClass:[UGActor class]];
    [actorMapping mapAttributes:@"displayName", @"picture", nil];
    
    RKObjectMapping* messageMapping = [RKObjectMapping mappingForClass:[UGActivitie class]];
    [messageMapping mapKeyPath:@"content" toAttribute:@"content"];
    [messageMapping mapKeyPath:@"type" toAttribute:@"type"];
    
    [messageMapping mapKeyPath:@"actor" toRelationship:@"actor" withMapping:actorMapping];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:messageMapping forKeyPath:@"entities"];
    
    [self loadMessageBoard];
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
    // Load message board every 5 seconds
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadMessageBoard) userInfo:NULL repeats:YES];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (timer) {
        [timer invalidate];
    }
	[super viewDidDisappear:animated];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    //NSLog(@"* Did load response: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    _statuses = objects;
    [_tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	NSLog(@"**Object loader did fail with Error: %@", error);
}



#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGSize size = [[[_statuses objectAtIndex:indexPath.row] content] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 9000)];
	return size.height + 60;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return [_statuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* reuseIdentifier = @"Cell Identifier";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    UIImageView *balloonView;
	UILabel *contentLabel;
    UILabel *usernameLabel;
    
	if (nil == cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;		
		
		balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
		balloonView.tag = 1;
        
        usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        usernameLabel.backgroundColor = [UIColor clearColor];
		usernameLabel.textColor = [UIColor colorWithRed:0.392 green:0.682 blue:0.847 alpha:1];
        usernameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        usernameLabel.tag = 3;
        
		contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		contentLabel.backgroundColor = [UIColor clearColor];
		contentLabel.tag = 2;
		contentLabel.numberOfLines = 0;
		contentLabel.lineBreakMode = UILineBreakModeWordWrap;
		contentLabel.font = [UIFont systemFontOfSize:14.0];
        
        
		UIView *message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
		message.tag = 0;
		[message addSubview:balloonView];
        [message addSubview:usernameLabel];
		[message addSubview:contentLabel];
		[cell.contentView addSubview:message];
		
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messageArrow"]];
        imageView.center = CGPointMake(65, 30);
        [cell.contentView addSubview:imageView];
        
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@", [[[_statuses objectAtIndex:indexPath.row] actor] picture] ]]];
        UIImage *imagee = [UIImage imageWithData:imageData];
        cell.imageView.image = [imagee imageScaledToSize:CGSizeMake(42, 42)];
        
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 22;
        cell.imageView.layer.borderColor = [[UIColor colorWithRed:0.169 green:0.169 blue:0.169 alpha:1] CGColor];
        cell.imageView.layer.borderWidth = 2;
	}
	else
	{
		balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
        usernameLabel = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:3];
		contentLabel = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
	}
	
	NSString *text = [[_statuses objectAtIndex:indexPath.row] content];
	CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12] constrainedToSize:CGSizeMake(230.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
	
	UIImage *balloon;
    balloonView.frame = CGRectMake(65, 15, 230, size.height + 55);
    balloon = [[UIImage imageNamed:@"ballon.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    contentLabel.frame = CGRectMake(70, 35, 210, size.height + 30);
    usernameLabel.frame = CGRectMake(70, 25, 230, 10);

    balloonView.image = balloon;
    usernameLabel.text = [[[_statuses objectAtIndex:indexPath.row] actor] displayName];
	contentLabel.text = text;
    
	return cell;
}

@end