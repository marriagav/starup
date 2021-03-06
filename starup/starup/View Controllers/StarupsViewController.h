//
//  StarupsViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "ComposeStarupViewController.h"
#import "Parse/Parse.h"
#import "StarupCellView.h"
#import "InfiniteScrollActivityView.h"
#import "ComposeStarupViewController.h"
#import "DetailsViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface StarupsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *starupsArray;
@property (nonatomic) int currentMax;

@end

NS_ASSUME_NONNULL_END
