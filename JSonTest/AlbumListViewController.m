//
//  AlbumListViewController.m
//  JSonTest
//
//  Created by Alexey Baranov on 20.01.2022.
//

#import "AlbumListViewController.h"

@interface AlbumListViewController ()

@end

@implementation AlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad AlbumList");
    self.title = @"Albums";
    albumsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [albumsTableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:AlbumCellIdentifier];
    [self.view addSubview:albumsTableView];
    albumsTableView.dataSource = self;
    albumsTableView.delegate = self;

    [ModelData.sharedInstance readAlbums];
    [albumsTableView performSelector:@selector(reloadData)
                                      withObject:nil
                                   afterDelay:1];
    photoListVC = [[PhotoListViewController alloc] initWithNibName:nil bundle:nil];
    photoListVC.title = @"Album Photos";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillApear albums");
    [albumsTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


// return number of sections in table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"Number of sections", ModelData.sharedInstance.albums.count);
    return 1;
}

// return number of rows for section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Number albums of rows %lu", ModelData.sharedInstance.albums.count);

    if (section == 0) {
        return ModelData.sharedInstance.albums.count;
    }
    return 0;
}

// return prefilled post cell for table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView
                dequeueReusableCellWithIdentifier:AlbumCellIdentifier
                forIndexPath:indexPath];
    
    Album *album = ModelData.sharedInstance.albums[indexPath.row];
    NSUInteger albumID = [album albumID];
    NSUInteger albumUserID = [album albumUserID];
    NSString *title = [album title];

    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 8;

    NSString *indexText = [NSString stringWithFormat:@"%lu:%lu ", albumID, albumUserID];
    NSMutableAttributedString *aText =
        [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:
                                        @"%@%@", indexText, title]];

// album title customization
    [aText addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:cell.textLabel.font.lineHeight]
                 range:NSMakeRange(indexText.length, title.length)];

    [aText addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blackColor]
                 range:NSMakeRange(indexText.length, title.length)];


    cell.textLabel.attributedText = aText;

    return cell;
}

// call when user select row in table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected post %lu", indexPath.row);

    [photoListVC setAlbum:ModelData.sharedInstance.albums[indexPath.row]];
    // read album photos
    [ModelData.sharedInstance readAlbumPhotos:[ModelData.sharedInstance.albums[indexPath.row] albumID]];
    [self.navigationController pushViewController:photoListVC animated:YES];
}

// returns height for table headers
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
/*
// return height of table row
- (CGFloat) tableView:(UITableView *)tableView
     heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       return 30.0f;
}
*/
@end
