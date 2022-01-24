//
//  PostComment.h
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//
#import <Foundation/Foundation.h>

static const NSString *POST_COMMENT_NAME = @"name";
static const NSString *POST_COMMENT_BODY = @"body";
static const NSString *POST_COMMENT_ID = @"id";
static const NSString *POST_ID_FOR_COMMENT = @"postId";
static const NSString *POST_COMMENT_EMAIL = @"email";

NS_ASSUME_NONNULL_BEGIN

// define post object
@interface PostComment : NSObject

// Post Comment name
@property NSString *name;
// Post Comment body
@property NSString *body;
// Post id
@property NSUInteger postID;
// Post Comment id
@property NSUInteger postCommentID;
// Post Comment email
@property NSString *email;

// init PostComment object from dictionary
-(instancetype)initWithDictionary: (NSDictionary *) dict;

@end

NS_ASSUME_NONNULL_END
