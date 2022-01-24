//
//  PhotoViewController.m
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad Photo");
    
    CGRect textRect = self.view.bounds;
    textRect.size.height = textRect.size.height / 5;
    textRect.origin.y = 20;
    textView = [[UITextView alloc] initWithFrame:textRect];
    [textView setEditable:NO];
    [self.view addSubview:textView];
    
    CGRect tableRect = self.view.bounds;
    tableRect.origin.y = tableRect.size.height / 5 + 20;
    tableRect.size.height = tableRect.size.height * 4 / 5 - 40;
    imageView = [[UIImageView alloc] initWithFrame:tableRect];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillApear Photo");

    NSLog(@"post thread = %@", [NSThread currentThread]);
    // register loading image notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoLoaded:) name:PHOTO_LOADED_NOTIFICATION object:nil];

    // Prepare attrubuted text for textView
    
    NSString *indexText = [NSString stringWithFormat:@"%lu:%lu ", album.albumID, album.albumUserID];
    NSMutableAttributedString *aText =
        [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:
                                        @"%@%@\n%@", indexText, album.title, albumPhoto.title]];

    [aText addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:20.]
                 range:NSMakeRange(0, aText.string.length)];

    // album title customization
    [aText addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:20.]
                 range:NSMakeRange(indexText.length, album.title.length)];

    [aText addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blackColor]
                 range:NSMakeRange(indexText.length, album.title.length)];

    // album photo title customization
    [aText addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:20.]
                 range:NSMakeRange(indexText.length + album.title.length, albumPhoto.title.length)];

    textView.attributedText = aText;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidApear Photo");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisapear Photo");
    // Remove data from table to avoid incorrect displaying next return
    if (self.isMovingFromParentViewController) {
//        [albumPhotos removeAllObjects];
    }
}

// received when thumbdail image is loaded
-(void)photoLoaded: (NSNotification *) notification {
    NSString *name = [notification name];
    NSIndexPath *index = [notification object];
    NSLog(@"name:%@ - object:%@", name, index);
    NSLog(@"post thread = %@", [NSThread currentThread]);
    
    // checks
    // set loaded image to imageView
    dispatch_async(dispatch_get_main_queue(),
     ^{
        self->imageView.image = self->albumPhoto.fullImage;
        NSLog(@"image update thread = %@", [NSThread currentThread]);
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
     });
}

// set post object for visualtiation
-(void)setAlbum: (Album *) albumParam andAlbumPhoto: (AlbumPhoto *) albumPhotoParam {
    album = albumParam;
    albumPhoto = albumPhotoParam;
}
@end
