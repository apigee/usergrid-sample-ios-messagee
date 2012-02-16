//
//  UGActor.h
//  Messagee
//
//  Created by Ernesto Vargas on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UGActor : NSObject {
	NSString* _displayName;
	NSString* _picture;
}

@property (nonatomic, retain) NSString* displayName;
@property (nonatomic, retain) NSString* picture;

@end
