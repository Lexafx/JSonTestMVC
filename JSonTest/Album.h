//
//  Album.h
//  JSonTest
//
//  Created by Alexey Baranov on 20.01.2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static const NSString *ALBUM_TITLE = @"title";
static const NSString *ALBUM_ID = @"id";
static const NSString *ALBUM_USER_ID = @"userId";

// define album object
@interface Album : NSObject

// album title
@property NSString *title;
// almub id
@property NSUInteger albumID;
// user id of album creator
@property NSUInteger albumUserID;

// init Post object from dictionary
-(instancetype)initWithDictionary: (NSDictionary *) dict;

@end

NS_ASSUME_NONNULL_END
