//
//  UGActivitie.h
//  Messagee
//
//  Created by Ernesto Vargas on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface UGActivitie : NSObject {  
    NSString *_content;
    NSString *_type;
}  

@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *type;

@end
