//
//  PhotoListViewController.m
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//

#import "PhotoListViewController.h"

@interface PhotoListViewController ()

@end

@implementation PhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad PhotoList");
    
    CGRect textRect = self.view.bounds;
    textRect.size.height = textRect.size.height / 5 - 20;
    textRect.origin.y = 20;
    textView = [[UITextView alloc] initWithFrame:textRect];
    [textView setEditable:NO];
    [self.view addSubview:textView];
    
    CGRect tableRect = self.view.bounds;
    tableRect.origin.y = tableRect.size.height / 5;
    tableRect.size.height = tableRect.size.height * 4 / 5 - 20;
    albumPhotosTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStyleGrouped];
    [albumPhotosTableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:PhotoListCell];
    [self.view addSubview:albumPhotosTableView];
    albumPhotosTableView.delegate = self;
    albumPhotosTableView.dataSource = self;
    
    // init photo view controller
    photoVC = [[PhotoViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillApear Comments");
    // clear privious table
    [albumPhotosTableView reloadData];
    // display new one after loaded
    [albumPhotosTableView performSelector:@selector(reloadData)
                                      withObject:nil
                                   afterDelay:0.5];

    NSLog(@"post thread = %@", [NSThread currentThread]);
    // register loading thumbdail notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thumbdailLoaded:) name:THUMBDAIL_LOADED_NOTIFICATION object:nil];

    // Prepare attrubuted text for textView
    
    NSString *indexText = [NSString stringWithFormat:@"%lu:%lu ", album.albumID, album.albumUserID];
    NSMutableAttributedString *aText =
        [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:
                                        @"%@%@", indexText, album.title]];

    [aText addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:20.]
                 range:NSMakeRange(0, aText.string.length)];

// post title customization
    [aText addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:20.]
                 range:NSMakeRange(indexText.length, album.title.length)];

    [aText addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blackColor]
                 range:NSMakeRange(indexText.length, album.title.length)];

    textView.attributedText = aText;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidApear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisapear");
    // Remove data from table to avoid incorrect displaying next return
    if (self.isMovingFromParentViewController) {
        [ModelData.sharedInstance clearAlbumPhotos];
    }
}

// received when thumbdail image is loaded
-(void)thumbdailLoaded: (NSNotification *) notification {
    NSString *name = [notification name];
    NSIndexPath *index = [notification object];
    NSLog(@"name:%@ - object:%@", name, index);
    NSLog(@"post thread = %@", [NSThread currentThread]);
    
    // checks if albumPhotos still exist
    if (ModelData.sharedInstance.albumPhotos.count > 0) {
        [albumPhotosTableView reloadData];
    }

}

// return number of sections in table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// return number of rows for section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return ModelData.sharedInstance.albumPhotos.count;
    }
    return 0;
}

// return prefilled post cell for table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    AlbumPhoto *albumPhoto = ModelData.sharedInstance.albumPhotos[indexPath.row];
    NSUInteger photoID = [albumPhoto photoID];
    NSUInteger albumID = [albumPhoto albumID];
    NSString *title = [albumPhoto title];
    NSString *url = [albumPhoto url];
    NSString *thumbnailUrl = [albumPhoto thumbnailUrl];
    UIImage *thumbnailImage = [albumPhoto thumbnailImage];

    cell = [tableView
                dequeueReusableCellWithIdentifier:PhotoListCell
                forIndexPath:indexPath];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 8;

    NSString *indexText = [NSString stringWithFormat:@"%lu:%lu ", albumID, photoID];
    NSMutableAttributedString *aText =
        [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:
                                        @"%@%@", indexText, title]];

// post name customization
    [aText addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:cell.textLabel.font.lineHeight]
                 range:NSMakeRange(indexText.length, title.length)];

    [aText addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blackColor]
                 range:NSMakeRange(indexText.length, title.length)];


    cell.textLabel.attributedText = aText;
    NSLog(@"%@", cell.textLabel.text);
    
    // add thumnail image if ready
    if (thumbnailImage != nil) {
        cell.imageView.image = thumbnailImage;
    }
    return cell;
}

// call when user select row in table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected post %lu", indexPath.row);
    // send album and album photo obects to ohotoVC
    AlbumPhoto *albumPhoto = ModelData.sharedInstance.albumPhotos[indexPath.row];
    [photoVC setAlbum:album andAlbumPhoto:albumPhoto];
    // start loading full image for selected row
    [ModelData.sharedInstance readAlbumFullPhoto:[albumPhoto url]];
    [self.navigationController pushViewController:photoVC animated:NO];
}

// returns height for table headers
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

// set post object for visualtiation
-(void)setAlbum: (Album *) albumParam {
    album = albumParam;
}



// display post on the in header of table
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // fixed font style. use custom view (UILabel) if you want something different
    return @"Album photos:";
}

@end
