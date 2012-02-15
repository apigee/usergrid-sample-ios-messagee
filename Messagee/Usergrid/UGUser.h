//
//  UGUser.h
//  Messagee
//
//  Created by Ernesto Vargas on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UGUser : NSObject {
    NSString *username;
    NSString *email;
}

+ (UGUser *)sharedInstance;

@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *email;

@end
