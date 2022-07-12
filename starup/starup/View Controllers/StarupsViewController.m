//
//  StarupsViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "StarupsViewController.h"

@interface StarupsViewController () <ComposeStarupViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation StarupsViewController

#pragma mark - Initialization

// Helper variables
bool _isMoreDataLoadingS = false;
InfiniteScrollActivityView* _loadingMoreViewS;

- (void)viewDidLoad {
    [super viewDidLoad];
    //  Initiallize delegate and datasource of the tableview to self
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self refreshDataWithNStarups:20];
    // Initialize a UIRefreshControl
    [self _initializeRefreshControl];
    // Initialize a UIRefreshControlBottom
    [self _initializeRefreshControlB];
}

#pragma mark - QualityOfLife

- (void)_initializeRefreshControl{
//    Initialices and inserts the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(_beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void)_initializeRefreshControlB{
//    Initialices and inserts the refresh control
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    _loadingMoreViewS = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    _loadingMoreViewS.hidden = true;
    [self.tableView addSubview:_loadingMoreViewS];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!_isMoreDataLoadingS){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            _isMoreDataLoadingS = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            _loadingMoreViewS.frame = frame;
            [_loadingMoreViewS startAnimating];
            
            // Code to load more results
            [self loadMoreData];
        }
    }
}

- (void)loadMoreData{
    //    Adds 20 more posts to the tableView, for infinte scrolling
    int postsToAdd = (int)[self.starupsArray count] + 20;
    [self refreshDataWithNStarups: postsToAdd];
    [_loadingMoreViewS stopAnimating];
}

#pragma mark - Network

- (void)refreshDataWithNStarups:(int) numberOfStarups {
    //    Refreshes the tableview data with numberOfPosts posts
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Starup"];
    [query orderByDescending:@"createdAt"];
    query.limit = numberOfStarups;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *starups, NSError *error) {
        if (starups != nil) {
            self.starupsArray = (NSMutableArray *) starups;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (void)_beginRefresh:(UIRefreshControl *)refreshControl {
//    Refreshes the data using the UIRefreshControl
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *starups, NSError *error) {
        if (starups != nil) {
            self.starupsArray = (NSMutableArray *) starups;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [refreshControl endRefreshing];
    }];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    //    return amount of posts in the postArray
    return self.starupsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    initialize cell (StarupCell) to a reusable cell using the StarupCell identifier
    StarupCell *cell = [tableView
                      dequeueReusableCellWithIdentifier: @"StarupCell"];
    //    get the starup and assign it to the cell
    Starup *starup = self.starupsArray[indexPath.row];
    cell.starup = starup;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    Calls load more data when scrolling reaches bottom of the tableView
    if(indexPath.row + 1 == [self.starupsArray count]){
        [self loadMoreData];
    }
}

#pragma mark - Delegates

- (void)didPost{
    //    Gets called when the user presses the "share" button on the "ComposePost" view, this controller functions as a delegate of the former
    [self refreshDataWithNStarups:(int)self.starupsArray.count+1];
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
