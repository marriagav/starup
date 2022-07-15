//
//  AddCollaboratorViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/14/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "profileCell.h"
#import "InfiniteScrollActivityView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AddCollaboratorViewControllerDelegate

- (void)didAddHacker:(PFUser *)user;
- (void)didAddShark:(PFUser *)user;
- (void)didAddIdeator:(PFUser *)user;

@end

@interface AddCollaboratorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *userArray;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSString *typeOfUserToAdd;
@property (nonatomic, weak) id<AddCollaboratorViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
