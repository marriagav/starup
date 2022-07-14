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

@interface AddCollaboratorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *userArray;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

NS_ASSUME_NONNULL_END
