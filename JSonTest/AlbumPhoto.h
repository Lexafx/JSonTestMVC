//
//  Album.h
//  JSonTest
//
//  Created by Alexey Baranov on 20.01.2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static const NSString *PHOTO_TITLE = @"title";
static const NSString *PHOTO_ID = @"id";
static const NSString *ALBUM_PHOTO_ID = @"albumId";
static const NSString *PHOTO_URL = @"url";
static const NSString *PHOTO_THUMBNAIL_URL = @"thumbnailUrl";

// define album photo object
@interface AlbumPhoto : NSObject

// album title
@property NSString *title;
// almub id
@property NSUInteger albumID;
// almub photo id
@property NSUInteger photoID;

// link to small thumbnail photo
@property NSString *thumbnailUrl;
// thumbnail image
@property UIImage *thumbnailImage;

// link to full photo
@property NSString *url;
// full image
@property UIImage *fullImage;

// init Post object from dictionary
-(instancetype)initWithDictionary: (NSDictionary *) dict;

@end

NS_ASSUME_NONNULL_END
