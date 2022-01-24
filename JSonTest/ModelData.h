//
//  ModelData.h
//  JSonTestMVC
//
//  Created by Alexey Baranov on 23.01.2022.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "PostComment.h"
#import "User.h"
#import "Album.h"
#import "AlbumPhoto.h"

NS_ASSUME_NONNULL_BEGIN

static const NSInteger URL_USERS_TYPE = 0;
static const NSInteger URL_POSTS_TYPE = 1;
static const NSInteger URL_POST_COMMENTS_TYPE = 2;
static const NSInteger URL_ALBUMS_TYPE = 3;
static const NSInteger URL_ALBUM_PHOTOS_TYPE = 4;
static const NSInteger URL_ALBUM_PHOTO_TYPE = 5;
static const NSInteger URL_ALBUM_FULL_PHOTO_TYPE = 6;

// addresses
static const NSString *ADDRESS_FOR_USERS = @"https://jsonplaceholder.typicode.com/users";
static const NSString *ADDRESS_FOR_POSTS = @"https://jsonplaceholder.typicode.com/posts";
static const NSString *ADDRESS_PART_FOR_POST_COMMENTS = @"/comments";
static const NSString *ADDRESS_FOR_ALBUMS = @"https://jsonplaceholder.typicode.com/albums";
static const NSString *ADDRESS_FOR_ALBUM_PHOTOS = @"https://jsonplaceholder.typicode.com/photos?albumId=";

// notifications
static const NSString *THUMBDAIL_LOADED_NOTIFICATION = @"ThumbdailLoadedNotification";
static const NSString *PHOTO_LOADED_NOTIFICATION = @"PhotoLoadedNotification";
static const NSString *USER_LOADED_NOTIFICATION = @"UserLoadedNotification";
static const NSString *POST_COMMENTS_LOADED_NOTIFICATION = @"PostCommentsLoadedNotification";

@interface ModelData : NSObject
{
    // array for posts. contains object Post
    NSMutableArray *posts;
    // dictionary for users. contains object User
    NSMutableDictionary *users;
    // array for post comments. contains oject post comments
    NSMutableArray *postComments;
    // array for albums. contains obect album
    NSMutableArray *albums;
    // array for album photos. contains obect album photos
    NSMutableArray *albumPhotos;
}

// block init method
-(instancetype)init UNAVAILABLE_ATTRIBUTE;
// define shared instance init method
+(instancetype)sharedInstance;

// return posts array
-(NSMutableArray *)posts;

// return users dictionary
-(NSMutableDictionary *)users;

// return post comments array
-(NSMutableArray *)postComments;

// return albums array
-(NSMutableArray *)albums;

// return album phots array
-(NSMutableArray *)albumPhotos;

// Read posts from URL
-(void)readPosts;

// Read users from URL
-(void)readUsers;

// Read post comments for postID from URL
-(void)readPostComments: (NSUInteger) postID;

// clear post comments
-(void)clearPostComments;

// Read albums from URL
-(void)readAlbums;

// Read album photos from URL
-(void)readAlbumPhotos: (NSUInteger) albumID;
// read album thumbdail photo
-(void)readAlbumPhoto: (NSString *) thumbdailAddress;
// read Album full photo
-(void)readAlbumFullPhoto: (NSString *) imageAddress;
// clear album photos
-(void)clearAlbumPhotos;

@end

NS_ASSUME_NONNULL_END
