//
//  ViewController.m
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//

#import "PostViewController.h"

@interface PostViewController ()

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad");
    self.title = @"Posts";
    self.postsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.postsTableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:TableViewCellIdentifier];
    [self.view addSubview:self.postsTableView];
    self.postsTableView.dataSource = self;
    self.postsTableView.delegate = self;

    // start loading users
    [ModelData.sharedInstance readUsers];

    // start loading posts from model data
    [ModelData.sharedInstance readPosts];

    [self.postsTableView performSelector:@selector(reloadData)
                                      withObject:nil
                                   afterDelay:1];
    commentVC = [[CommentViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillApear");
    
    // register loading users notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoaded:) name:USER_LOADED_NOTIFICATION object:nil];
    
    [self.postsTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

// received when users are loaded
-(void)userLoaded: (NSNotification *) notification {
    NSString *name = [notification name];
    NSLog(@"name:%@ ", name);
    
    // checks
    // set loaded image to imageView
    dispatch_async(dispatch_get_main_queue(),
     ^{
        [self->_postsTableView reloadData];
        NSLog(@"Users update thread = %@", [NSThread currentThread]);
     });
}

// return number of sections in table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"Number of sections %lu", [ModelData.sharedInstance posts].count);
    return 1;
}

// return number of rows for section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Number of rows %lu",     [ModelData.sharedInstance posts].count);

    if (section == 0) {
        return [ModelData.sharedInstance posts].count;
    }
    return 0;
}

// return prefilled post cell for table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView
                dequeueReusableCellWithIdentifier:TableViewCellIdentifier
                forIndexPath:indexPath];
    
    Post *post = [ModelData.sharedInstance posts][indexPath.row];
    
    NSUInteger postID = [post postID];
    NSUInteger postUserID = [post postUserID];
    NSString *body = [post body];
    NSString *title = [post title];
    NSMutableString *userName = [[NSMutableString alloc] initWithString:@""];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 8;

    NSString *indexText = [NSString stringWithFormat:@"%lu:%lu ", postID, postUserID];
    NSString *mainText;
    // if users loaded
    if (ModelData.sharedInstance.users.count > 0) {
        User *user = [ModelData.sharedInstance.users valueForKey: [NSString stringWithFormat:@"%lu", postUserID]];
        [userName appendFormat:@"  %@", user.username];
    }
    mainText = [NSString stringWithFormat:@"%@%@%@\n%@", indexText, title, userName, body];
    NSMutableAttributedString *aText =
        [[NSMutableAttributedString alloc] initWithString: mainText];

// post title customization
    [aText addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:cell.textLabel.font.lineHeight]
                 range:NSMakeRange(indexText.length, title.length)];

    [aText addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blackColor]
                 range:NSMakeRange(indexText.length, title.length)];

// username customisation
    [aText addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:cell.textLabel.font.lineHeight]
                 range:NSMakeRange(indexText.length + title.length, userName.length)];

    [aText addAttribute:NSForegroundColorAttributeName
                 value:[UIColor greenColor]
                 range:NSMakeRange(indexText.length + title.length, userName.length)];

    cell.textLabel.attributedText = aText;

    return cell;
}

// call when user select row in table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected post %lu", indexPath.row);
    Post *post = [ModelData.sharedInstance posts][indexPath.row];
    User *user = nil;

    if (ModelData.sharedInstance.users.count) {
        user = [ModelData.sharedInstance.users valueForKey: [NSString stringWithFormat:@"%lu", post.postUserID]];
    }
    // init vc with post and user
    [commentVC setPost:post forUser:user];
    // read post comments data
    [ModelData.sharedInstance readPostComments: post.postID];
    [self.navigationController pushViewController:commentVC animated:YES];
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
