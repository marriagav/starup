//
//  ResultsViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/27/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "profileCell.h"
#import "InfiniteScrollActivityView.h"
#import "connectionsGraph.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ResultsViewControllerDelegate

- (void)didTapUser:(PFUser *)user;

@end

@interface ResultsViewController : UIViewController

@property (strong, nonatomic) NSMutableArray<NSMutableArray *> *userMatrix;
@property (nonatomic, weak) id<ResultsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void) searchForSubstring: (NSString *)searchText;

@end

NS_ASSUME_NONNULL_END
