//
//  HomeViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "HomeViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, PostCellDelegate, ComposePostViewControllerDelegate>

@end

@implementation HomeViewController

#pragma mark - Initialization

// Helper variables
bool _isMoreDataLoading = false;
InfiniteScrollActivityView* _loadingMoreView;

- (void)viewDidLoad {
    [super viewDidLoad];
    //  Initiallize delegate and datasource of the tableview to self
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self refreshDataWithNPosts:20];
    // Initialize a UIRefreshControl
    [self _initializeRefreshControl];
    // Initialize a UIRefreshControlBottom
    self.currentMax = 20;
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
    _loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    _loadingMoreView.hidden = true;
    [self.tableView addSubview:_loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!_isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            _isMoreDataLoading = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            _loadingMoreView.frame = frame;
            [_loadingMoreView startAnimating];
            
            // Code to load more results
            [self loadMoreData];
        }
    }
}

- (void)loadMoreData{
    //    Adds 20 more posts to the tableView, for infinte scrolling
    if ([self.postArray count]>=self.currentMax){
        self.currentMax+=20;
        int postsToAdd = (int)[self.postArray count] + 20;
        [self refreshDataWithNPosts: postsToAdd];
    }
    [_loadingMoreView stopAnimating];
}

#pragma mark - Network

- (void)refreshDataWithNPosts:(int) numberOfPosts {
    //    Refreshes the tableview data with numberOfPosts posts
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = numberOfPosts;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postArray = (NSMutableArray *) posts;
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
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postArray = (NSMutableArray *) posts;
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
    return self.postArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    initialize cell (PostCell) to a reusable cell using the PostCell identifier
    PostCell *cell = [tableView
                      dequeueReusableCellWithIdentifier: @"PostCell"];
    //    get the post and delegate and assign it to the cell
    Post *post = self.postArray[indexPath.row];
    cell.post=post;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    Calls load more data when scrolling reaches bottom of the tableView
    if(indexPath.row + 1 == [self.postArray count]){
        [self loadMoreData];
    }
}

#pragma mark - Delegates

- (void)didPost{
    //    Gets called when the user presses the "share" button on the "ComposePost" view, this controller functions as a delegate of the former
    [self refreshDataWithNPosts:(int)self.postArray.count+1];
}

- (void)postCell:(PostCell *)postCell didTap:(PFUser *)user{
//    Goes to profile page when user taps on profile
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ProfileViewController *profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    [navigationController setModalPresentationStyle:UIModalPresentationFullScreen];
    // Pass the user
    profileViewController.user = user;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)composeAPost:(id)sender {
    // display compose post view controller
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ComposePostViewController *postViewController = [storyboard instantiateViewControllerWithIdentifier:@"composeNoNav"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:postViewController];
    [navigationController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController presentViewController:navigationController animated:YES completion:^{
        // Pass the delegate
        postViewController.delegate = self;
    }];
}

@end
