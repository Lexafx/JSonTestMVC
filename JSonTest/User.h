//
//  User.h
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//
#import <Foundation/Foundation.h>

static const NSString *USER_USERNAME = @"username";
static const NSString *USER_NAME = @"name";
static const NSString *USER_ID = @"id";
static const NSString *USER_EMAIL = @"email";

NS_ASSUME_NONNULL_BEGIN

// define post object
@interface User : NSObject

// username title
@property NSString *username;
// name of user
@property NSString *name;
// user id
@property NSUInteger userID;
// email of user
@property NSString *email;

// init Post object from dictionary
-(instancetype)initWithDictionary: (NSDictionary *) dict;

@end

NS_ASSUME_NONNULL_END
