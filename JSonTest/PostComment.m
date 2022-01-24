//
//  PostComment.m
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//

#import "PostComment.h"

@implementation PostComment

@synthesize name;
@synthesize body;
@synthesize email;
@synthesize postCommentID;
@synthesize postID;

// init PostComment object from dictionary
-(instancetype)initWithDictionary: (NSDictionary *) dict {
    self = [super init];
    if (self && dict != nil) {
        postCommentID = [[dict valueForKey:POST_COMMENT_ID] unsignedIntegerValue];
        postID = [[dict valueForKey:POST_ID_FOR_COMMENT] unsignedIntegerValue];
        name = [dict valueForKey:POST_COMMENT_NAME];
        body = [dict valueForKey:POST_COMMENT_BODY];
        email = [dict valueForKey:POST_COMMENT_EMAIL];
    }
    return self;
}

@end
