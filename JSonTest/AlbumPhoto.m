//
//  Album.m
//  JSonTest
//
//  Created by Alexey Baranov on 20.01.2022.
//

#import "AlbumPhoto.h"

@implementation AlbumPhoto

@synthesize title;
@synthesize albumID;
@synthesize photoID;
@synthesize url;
@synthesize thumbnailUrl;
@synthesize thumbnailImage;
@synthesize fullImage;


// init Album object from dictionary
-(instancetype)initWithDictionary: (NSDictionary *) dict {
    self = [super init];
    if (self && dict != nil) {
        albumID = [[dict valueForKey:ALBUM_PHOTO_ID] unsignedIntegerValue];
        title = [dict valueForKey:PHOTO_TITLE];
        photoID = [[dict valueForKey:PHOTO_ID] unsignedIntegerValue];
        url = [dict valueForKey:PHOTO_URL];
        thumbnailUrl = [dict valueForKey:PHOTO_THUMBNAIL_URL];
        thumbnailImage = nil;
        fullImage = nil;
    }
    return self;
}

@end
