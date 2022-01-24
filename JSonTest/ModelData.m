//
//  ModelData.m
//  JSonTestMVC
//
//  Created by Alexey Baranov on 23.01.2022.
//

#import "ModelData.h"

@implementation ModelData

// define shared instance init method
+(instancetype)sharedInstance {
    // static singlton model object for application
    static ModelData *modelInstance = nil;

    // create object only once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            modelInstance = [[ModelData alloc] initPrivate];
    });
    return modelInstance ;
}

// private init method
-(instancetype)initPrivate {
    self = [super init];
    // init internal objects
    if (self) {
        // init posts array
        posts = [[NSMutableArray alloc] initWithCapacity:100];
        // init users dictionary
        users = [[NSMutableDictionary alloc] initWithCapacity:100];
        // init post comments array
        postComments = [[NSMutableArray alloc] initWithCapacity:100];
        // init albums array
        albums = [[NSMutableArray alloc] initWithCapacity:100];
        // init album photos array
        albumPhotos = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

// return posts arry
-(NSMutableArray *)posts {
    return posts;
}
// return users dictionary
-(NSMutableDictionary *)users {
    return users;
}

// return post comments array
-(NSMutableArray *)postComments {
    return postComments;
}

// return albums array
-(NSMutableArray *)albums {
    return albums;
}

// return album phots array
-(NSMutableArray *)albumPhotos {
    return albumPhotos;
}

// Read posts from URL
-(void)readPosts {
    [self readDataFromAddress: ADDRESS_FOR_POSTS forType: URL_POSTS_TYPE];
}

// Read users from URL
-(void)readUsers {
    [self readDataFromAddress: ADDRESS_FOR_USERS forType: URL_USERS_TYPE];
}

// Read post comments for postID from URL
-(void)readPostComments: (NSUInteger) postID {
    NSString *address = [NSString stringWithFormat:@"%@/%lu%@", ADDRESS_FOR_POSTS, postID, ADDRESS_PART_FOR_POST_COMMENTS];
    [self readDataFromAddress: address forType: URL_POST_COMMENTS_TYPE];
}

-(void)readAlbums {
    [self readDataFromAddress: ADDRESS_FOR_ALBUMS forType: URL_ALBUMS_TYPE];
}

// read album photos list
-(void)readAlbumPhotos: (NSUInteger) albumID {
    NSString *address = [NSString stringWithFormat:@"%@%lu", ADDRESS_FOR_ALBUM_PHOTOS, albumID];
    [self readDataFromAddress: address forType: URL_ALBUM_PHOTOS_TYPE];
}

// read album thumbdail photo
-(void)readAlbumPhoto: (NSString *) thumbdailAddress {
    [self readDataFromAddress: thumbdailAddress forType: URL_ALBUM_PHOTO_TYPE];
}

// read Album full photo
-(void)readAlbumFullPhoto: (NSString *) imageAddress {
    [self readDataFromAddress: imageAddress forType: URL_ALBUM_FULL_PHOTO_TYPE];
}

// fill album photo data into album photos array
-(void)fillAlbumPhotosData: (NSArray *)arr {
    AlbumPhoto *albumPhoto;
    NSDictionary *dict;
    
    // remove all objects
    [albumPhotos removeAllObjects];
    
    for (dict in arr){
        albumPhoto = [[AlbumPhoto alloc] initWithDictionary:dict];
        [albumPhotos addObject:albumPhoto];
        [self readAlbumPhoto:[albumPhoto thumbnailUrl]];
    }
}

// fill album data into albums array
-(void)fillAlbumsData: (NSArray *)arr {
    Album *album;
    NSDictionary *dict;
    
    // remove all objects
    [albums removeAllObjects];
    
    for (dict in arr){
        album = [[Album alloc] initWithDictionary:dict];
        [albums addObject:album];
    }
    NSLog(@"albums loaded %lu", albums.count);
}

// fill post comments data into post comments array
-(void)fillPostCommentsData: (NSArray *)arr {
    PostComment *comment;
    NSDictionary *dict;
    
    // remove all objects
    [postComments removeAllObjects];
    
    for (dict in arr){
        comment = [[PostComment alloc] initWithDictionary:dict];
        [postComments addObject:comment];
    }
    
    // send notification to update table with users loaded
    [[NSNotificationCenter defaultCenter] postNotificationName: POST_COMMENTS_LOADED_NOTIFICATION object: nil];

    NSLog(@"Post comment records %lu", arr.count);
}

// fill posts data into posts array
-(void)fillPostsData: (NSArray *)arr {
    Post *post;
    NSDictionary *dict;
    
    // remove all objects
    [posts removeAllObjects];
    
    for (dict in arr){
        post = [[Post alloc] initWithDictionary:dict];
        [posts addObject:post];
    }
}

// fill posts data into posts array
-(void)fillUsersData: (NSArray *)arr {
    User *user;
    NSDictionary *dict;
    
    // remove all objects
    [users removeAllObjects];
    
    for (dict in arr){
        user = [[User alloc] initWithDictionary:dict];
        [users setValue:user forKey:[NSString stringWithFormat:@"%lu", user.userID]];
    }
    // send notification to update table with users loaded
    [[NSNotificationCenter defaultCenter] postNotificationName: USER_LOADED_NOTIFICATION object: nil];

}

// Read data from URL
-(void)readDataFromAddress: (NSString *) address forType: (NSUInteger) type  {
    NSURL *mainURL = [NSURL URLWithString:address];
    NSURLRequest *request = [NSURLRequest requestWithURL:mainURL];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask;
    
    dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([data length] >0  && error == nil){
            NSString *html = [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
//            NSLog(@"data = %@", html);

            NSError *err;
            NSArray *arr = nil;
            
            NSObject *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:&err];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSLog(@"NSDictionaty");
            } else if ([obj isKindOfClass:[NSArray class]]) {
                NSLog(@"NSArray");
                arr = (NSArray *)obj;
                NSLog(@"Array count %lu", arr.count);
                
                switch (type) {
                    case URL_POSTS_TYPE:
                        // store data to posts array
                        [self fillPostsData:arr];
                        break;
                    case URL_USERS_TYPE:
                        // store data to users dictionary
                        [self fillUsersData:arr];
                        break;
                    case URL_ALBUMS_TYPE:
                        // store data to albums array
                        [self fillAlbumsData:arr];
                        break;
                    case URL_ALBUM_PHOTOS_TYPE:
                        // store data to album photos array
                        [self fillAlbumPhotosData:arr];
                        break;
                    case URL_POST_COMMENTS_TYPE:
                        // store data to post comments array
                        [self fillPostCommentsData:arr];
                        break;
                }
            } else if (type == URL_ALBUM_PHOTO_TYPE) {
                // store thumbdail image to album photo
                [self attachImageToAlbumPhoto:[UIImage imageWithData:data] for:[response.URL absoluteString] asThumbdail: YES];
            } else if (type == URL_ALBUM_FULL_PHOTO_TYPE) {
                // store full image to album photo
                [self attachImageToAlbumPhoto:[UIImage imageWithData:data] for:[response.URL absoluteString] asThumbdail: NO];
            }
            // notify view controler about data changes
                
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Nothing was downloaded.");
        }
        else if (error != nil){
            NSLog(@"Error happened = %@", error);
        }
        
        }];
    
    [dataTask resume];
}

// clear post comments
-(void)clearPostComments {
    [postComments removeAllObjects];
}

// clear album photos
-(void)clearAlbumPhotos {
    [albumPhotos removeAllObjects];
}

// attach image to album photo
-(void)attachImageToAlbumPhoto:(UIImage *) img for:(NSString *) url asThumbdail:(BOOL) isThumbdail {
    NSIndexPath *indexPath;
    
    for (NSUInteger i = 0; i < albumPhotos.count; i++) {
        if (isThumbdail && [url isEqualToString:[albumPhotos[i] thumbnailUrl]]) {
            [albumPhotos[i] setThumbnailImage:img];
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];

            // send notification to update table with thumbdail image
            [[NSNotificationCenter defaultCenter] postNotificationName: THUMBDAIL_LOADED_NOTIFICATION object: indexPath];

            return;
        } else if (!isThumbdail && [url isEqualToString:[albumPhotos[i] url]]) {
            [albumPhotos[i] setFullImage:img];
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            // send notification to photo image to albumPhoto object
            [[NSNotificationCenter defaultCenter] postNotificationName:PHOTO_LOADED_NOTIFICATION object:nil];

            return;
        }
    }
}

@end
