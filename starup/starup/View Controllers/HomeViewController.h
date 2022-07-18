//
//  HomeViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "PostCell.h"
#import "InfiniteScrollActivityView.h"
#import "ComposePostViewController.h"
#import "ProfileViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *postArray;
@property (nonatomic) int currentMax;

@end

NS_ASSUME_NONNULL_END
