//
//  AlbumListViewController.h
//  JSonTest
//
//  Created by Alexey Baranov on 20.01.2022.
//

#import <UIKit/UIKit.h>
#import "AlbumPhoto.h"
#import "Album.h"
#import "PhotoListViewController.h"
#import "ModelData.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *AlbumCellIdentifier = @"albumCell";

@interface AlbumListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    // table view for albums
    UITableView *albumsTableView;
    PhotoListViewController *photoListVC;
}

@end

NS_ASSUME_NONNULL_END
