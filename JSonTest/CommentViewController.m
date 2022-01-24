//
//  CommentViewController.m
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad Comments");
    
    CGRect textRect = self.view.bounds;
    textRect.size.height = textRect.size.height / 2 - 20;
    textRect.origin.y = 20;
    textView = [[UITextView alloc] initWithFrame:textRect];
//    textView.backgroundColor = [UIColor yellowColor];
    [textView setEditable:NO];
    [self.view addSubview:textView];
    
    CGRect tableRect = self.view.bounds;
    tableRect.origin.y = tableRect.size.height / 2;
    tableRect.size.height = tableRect.size.height / 2 - 20;
    self.postCommentsTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStyleGrouped];
    [self.postCommentsTableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:TableViewCellComment];
    [self.view addSubview:self.postCommentsTableView];
    self.postCommentsTableView.delegate = self;
    self.postCommentsTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillApear Comments");
    // clear privious table
    [self.postCommentsTableView reloadData];
    // display new one after loaded
    [self.postCommentsTableView performSelector:@selector(reloadData)
                                      withObject:nil
                                   afterDelay:0.5];

    // Prepare attrubuted text for textView
    
    NSString *indexText = [NSString stringWithFormat:@"%lu:%lu ", post.postID, post.postUserID];
    NSString *mainText;
    NSMutableString *userName = [[NSMutableString alloc] initWithString:@""];

    // if user loaded
    if (user != nil) {
        [userName appendFormat:@"  %@", user.username];
    }
    mainText = [NSString stringWithFormat:@"%@%@%@\n%@", indexText, post.title, userName, post.body];
    NSMutableAttributedString *aText =
        [[NSMutableAttributedString alloc] initWithString: mainText];

// set font size for whole range
    [aText addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:20]
                 range:NSMakeRange(0, mainText.length)];
    
// post title customization
    [aText addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:20]
                 range:NSMakeRange(indexText.length, post.title.length)];

    [aText addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blackColor]
                 range:NSMakeRange(indexText.length, post.title.length)];

// username customisation
    [aText addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:20]
                 range:NSMakeRange(indexText.length + post.title.length, userName.length)];

    [aText addAttribute:NSForegroundColorAttributeName
                 value:[UIColor greenColor]
                 range:NSMakeRange(indexText.length + post.title.length, userName.length)];

    textView.attributedText = aText;

    // register loading post comments notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postCommentsLoaded:) name:POST_COMMENTS_LOADED_NOTIFICATION object:nil];

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
        [ModelData.sharedInstance clearPostComments];
    }
}

// received when post comments are loaded
-(void)postCommentsLoaded: (NSNotification *) notification {
    NSString *name = [notification name];
    NSLog(@"name:%@ ", name);
    
    dispatch_async(dispatch_get_main_queue(),
     ^{
        [self->_postCommentsTableView reloadData];
        NSLog(@"Post comments update thread = %@", [NSThread currentThread]);
     });
}

// return number of sections in table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// return number of rows for section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return ModelData.sharedInstance.postComments.count;
    }
    return 0;
}

// return prefilled post cell for table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    PostComment *postComment = ModelData.sharedInstance.postComments[indexPath.row];
    NSUInteger postID = [postComment postID];
    NSUInteger commentID = [postComment postCommentID];
    NSString *email = [postComment email];
    NSString *body = [postComment body];
    NSString *name = [postComment name];

    cell = [tableView
                dequeueReusableCellWithIdentifier:TableViewCellComment
                forIndexPath:indexPath];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 8;

    NSString *indexText = [NSString stringWithFormat:@"%lu:%lu ", postID, commentID];
    NSMutableAttributedString *aText =
        [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:
                                        @"%@%@\n%@\n%@", indexText, name, body, email]];

// post name customization
    [aText addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:cell.textLabel.font.lineHeight]
                 range:NSMakeRange(indexText.length, name.length)];

    [aText addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blackColor]
                 range:NSMakeRange(indexText.length, name.length)];

// post email customization
    [aText addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blueColor]
                 range:NSMakeRange(aText.length - email.length, email.length)];

    cell.textLabel.attributedText = aText;
    NSLog(@"%@", cell.textLabel.text);
    return cell;
}

// call when user select row in table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected post %lu", indexPath.row);
}

// returns height for table headers
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

// set post object for visualtiation
-(void)setPost: (Post *) postParam forUser: (User *) userParam{
    post = postParam;
    user = userParam;
}



// display post on the in header of table
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // fixed font style. use custom view (UILabel) if you want something different
    return @"Comments:";
}

@end
