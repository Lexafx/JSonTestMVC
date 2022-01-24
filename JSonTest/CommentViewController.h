//
//  CommentViewController.h
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//

#import <UIKit/UIKit.h>
#import "PostComment.h"
#import "Post.h"
#import "User.h"
#import "ModelData.h"

static NSString *TableViewCellComment = @"postCommentCell";

@interface CommentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    // post for visualitation
    Post *post;
    // field for post visualisation
    User *user;
    // field for post visualisation
    UITextView *textView;
}
@property (strong, nonatomic) UITableView *postCommentsTableView;

-(void)setPost: (Post *) post forUser:(User *) user;

@end

