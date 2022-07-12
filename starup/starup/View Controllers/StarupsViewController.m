//
//  StarupsViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "StarupsViewController.h"

@interface StarupsViewController () <ComposeStarupViewControllerDelegate>

@end

@implementation StarupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)refreshDataWithNStarups:(int) numberOfStarups{
    //    Refreshes the tableview data with numberOfPosts posts
    // construct query
    
    
    // fetch data asynchronously
    
}

- (void)_beginRefresh:(UIRefreshControl *)refreshControl {
    //    Refreshes the data using the UIRefreshControl
    // construct query
    
    
    // fetch data asynchronously
    
}


- (void)_initializeRefreshControl{
    //    Initialices and inserts the refresh control
    
    
}

- (void)_initializeRefreshControlB{
    //    Initialices and inserts the refresh control
    // Set up Infinite Scroll loading indicator
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    //    return amount of starups in the starupsArray
    
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    //    initialize cell (StarupCell) to a reusable cell using the StarupCell identifier
    
    //    get the post and delegate and assign it to the cell
    
    return NULL;
    
}

- (void)didPost{
    //    Gets called when the user presses the "share" button on the "ComposeStarup" view, this controller functions as a delegate of the former
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    Calls load more data when scrolling reaches bottom of the tableView
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    Checks if is scrolling
}

- (void)loadMoreData{
    //    Adds 20 more starups to the tableView, for infinte scrolling
    
}

#pragma mark - Actions

- (IBAction)composeAStarup:(id)sender {
    // display compose post view controller
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ComposeStarupViewController *composeStarupViewController = [storyboard instantiateViewControllerWithIdentifier:@"composeSNoNav"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeStarupViewController];
    [navigationController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController presentViewController:navigationController animated:YES completion:^{
        // Pass the delegate
        composeStarupViewController.delegate = self;
    }];
}

@end
