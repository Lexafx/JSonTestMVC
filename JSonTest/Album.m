//
//  Album.m
//  JSonTest
//
//  Created by Alexey Baranov on 20.01.2022.
//

#import "Album.h"

@implementation Album

@synthesize title;
@synthesize albumUserID;
@synthesize albumID;

// init Album object from dictionary
-(instancetype)initWithDictionary: (NSDictionary *) dict {
    self = [super init];
    if (self && dict != nil) {
        albumID = [[dict valueForKey:ALBUM_ID] unsignedIntegerValue];
        title = [dict valueForKey:ALBUM_TITLE];
        albumUserID = [[dict valueForKey:ALBUM_USER_ID] unsignedIntegerValue];
    }
    return self;
}

@end
