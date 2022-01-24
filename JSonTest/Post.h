//
//  Post.h
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//
#import <Foundation/Foundation.h>

static const NSString *POST_TITLE = @"title";
static const NSString *POST_BODY = @"body";
static const NSString *POST_ID = @"id";
static const NSString *POST_USER_ID = @"userId";

NS_ASSUME_NONNULL_BEGIN

// define post object
@interface Post : NSObject

// post title
@property NSString *title;
// post body
@property NSString *body;
// post id
@property NSUInteger postID;
// user id of post creator
@property NSUInteger postUserID;

// init Post object from dictionary
-(instancetype)initWithDictionary: (NSDictionary *) dict;

@end

NS_ASSUME_NONNULL_END
