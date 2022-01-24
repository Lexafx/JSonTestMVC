//
//  PostViewController.h
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Post.h"
#import "CommentViewController.h"
#import "ModelData.h"

static const NSString *TableViewCellIdentifier = @"postCell";

@interface PostViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    // Posts data loaded from ModelData singlton shredInstance
    
    CommentViewController *commentVC;
}
@property (strong, nonatomic) UITableView *postsTableView;

@end

