//
//  PhotoListViewController.h
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "AlbumPhoto.h"
#import "PhotoViewController.h"
#import "ModelData.h"

static NSString *PhotoListCell = @"photoListCell";

@interface PhotoListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    // album for visualitation
    Album *album;
    // field for post visualisation
    UITextView *textView;
    // album photos table
    UITableView *albumPhotosTableView;
    // view controller VC for full image photo visualisation
    PhotoViewController *photoVC;

}

-(void)readAlbumPhotos: (NSUInteger) albumID;
-(void)setAlbum: (Album *) album;

@end

