//
//  User.m
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//

#import "User.h"

@implementation User

@synthesize username;
@synthesize name;
@synthesize userID;
@synthesize email;

// init Post object from dictionary
-(instancetype)initWithDictionary: (NSDictionary *) dict {
    self = [super init];
    if (self && dict != nil) {
        userID = [[dict valueForKey:USER_ID] unsignedIntegerValue];
        username = [dict valueForKey:USER_USERNAME];
        name = [dict valueForKey:USER_NAME];
        email = [dict valueForKey:USER_EMAIL];
    }
    return self;
}

@end
