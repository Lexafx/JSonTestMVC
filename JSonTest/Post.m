//
//  Post.m
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//

#import "Post.h"

@implementation Post

@synthesize title;
@synthesize body;
@synthesize postUserID;
@synthesize postID;

// init Post object from dictionary
-(instancetype)initWithDictionary: (NSDictionary *) dict {
    self = [super init];
    if (self && dict != nil) {
        postID = [[dict valueForKey:POST_ID] unsignedIntegerValue];
        title = [dict valueForKey:POST_TITLE];
        body = [dict valueForKey:POST_BODY];
        postUserID = [[dict valueForKey:POST_USER_ID] unsignedIntegerValue];
    }
    return self;
}

@end
