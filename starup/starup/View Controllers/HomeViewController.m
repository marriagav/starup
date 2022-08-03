//
//  HomeViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "HomeViewController.h"


@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, PostCellViewDelegate, ComposePostViewControllerDelegate>

@end


@implementation HomeViewController

#pragma mark - Initialization

// Helper variables
bool _isMoreDataLoading = false;
InfiniteScrollActivityView *_loadingMoreView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  Initiallize delegate and datasource of the tableview to self
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.closeConnectionsArray = [[NSMutableArray alloc] init];
    [self refreshDataWithNPosts:20];
    // Initialize a UIRefreshControl
    [self initializeRefreshControl];
    // Initialize a UIRefreshControlBottom
    self.currentMax = 20;
    [self initializeRefreshControlB];
    //    Add starup image
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    [self.navigationItem setTitle:@"Home feed"];
}

#pragma mark - QualityOfLife

- (void)initializeRefreshControl
{
    //    Initialices and inserts the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView setRefreshControl:refreshControl];
}

- (void)initializeRefreshControlB
{
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isMoreDataLoading) {
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;

        // When the user has scrolled past the threshold, start requesting
        if (scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
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

- (void)loadMoreData
{
    //    Adds 20 more posts to the tableView, for infinte scrolling
    if ([self.postArray count] >= self.currentMax) {
        self.currentMax += 20;
        int postsToAdd = (int)[self.postArray count] + 20;
        [self refreshDataWithNPosts:postsToAdd];
    }
    [_loadingMoreView stopAnimating];
}

#pragma mark - Network

- (void)buildCloseConnectionsArray
{
    ConnectionsGraph *graph = [ConnectionsGraph sharedInstance];
    for (UserNode *node in graph.nodes) {
        [self.closeConnectionsArray addObject:node.user];
    }
}

- (void)addCloseConnectionsPosts:(int)numberOfPosts withRefreshControl:(UIRefreshControl *)refreshControl
{
    //    Refreshes the tableview data with numberOfPosts posts from close connections
    [self buildCloseConnectionsArray];
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" containedIn:self.closeConnectionsArray];
    query.limit = numberOfPosts;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postArray = (NSMutableArray *)posts;
            int postsLeftToadd = numberOfPosts - (int)[posts count];
            if (postsLeftToadd >= 1) {
                [self addNotCloseConnectionsPosts:postsLeftToadd withRefreshControl:refreshControl];
            }
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)addNotCloseConnectionsPosts:(int)numberOfPosts withRefreshControl:(UIRefreshControl *)refreshControl
{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" notContainedIn:self.closeConnectionsArray];
    query.limit = numberOfPosts;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            [self.postArray addObjectsFromArray:(NSMutableArray *)posts];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        if (refreshControl) {
            [refreshControl endRefreshing];
        }
    }];
}

- (void)refreshDataWithNPosts:(int)numberOfPosts
{
    [self addCloseConnectionsPosts:numberOfPosts withRefreshControl:nil];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl
{
    //    Refreshes the data using the UIRefreshControl
    // construct query
    [self addCloseConnectionsPosts:20 withRefreshControl:refreshControl];
}

- (void)checkIfConnectionExists:(PFUser *)user withCloseness:(int)closenesss
{
    //    checks if two users are already close, if they are, make their connection stronger, if theyre not, create a connection between them
    PFQuery *query1 = [PFQuery queryWithClassName:@"UserConnection"];
    [query1 whereKey:@"userOne" equalTo:PFUser.currentUser];
    [query1 whereKey:@"userTwo" equalTo:user];

    PFQuery *query2 = [PFQuery queryWithClassName:@"UserConnection"];
    [query2 whereKey:@"userTwo" equalTo:PFUser.currentUser];
    [query2 whereKey:@"userOne" equalTo:user];

    PFQuery *find = [PFQuery orQueryWithSubqueries:@[ query1, query2 ]];
    [find includeKey:@"userOne"];
    [find includeKey:@"userTwo"];

    [find getFirstObjectInBackgroundWithBlock:^(PFObject *parseObject, NSError *error) {
        if (parseObject) {
            float currCloseness = [parseObject[@"closeness"] floatValue];
            parseObject[@"closeness"] = [NSNumber numberWithFloat:currCloseness + closenesss];
            [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
                if (succeeded) {
                    // Add connection to local graph
                    ConnectionsGraph *graph = [ConnectionsGraph sharedInstance];
                    [graph addUserToGraph:user withCompletion:nil];
                }
            }];
        } else {
            //    Posts a user connection
            [UserConnection postUserConnection:PFUser.currentUser withUserTwo:user withCloseness:@(closenesss) withCompletion:^(BOOL succeeded, NSError *_Nullable error) {
                // Add connection to local graph
                ConnectionsGraph *graph = [ConnectionsGraph sharedInstance];
                [graph addUserToGraph:user withCompletion:nil];
            }];
        }
    }];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    //    return amount of posts in the postArray
    return self.postArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    initialize cell (PostCell) to a reusable cell using the PostCell identifier
    PostCellView *cell = [tableView
        dequeueReusableCellWithIdentifier:@"PostCell"];
    //    get the post and delegate and assign it to the cell
    Post *post = self.postArray[indexPath.row];
    cell.post = post;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    Calls load more data when scrolling reaches bottom of the tableView
    if (indexPath.row + 1 == [self.postArray count]) {
        [self loadMoreData];
    }
}

#pragma mark - Delegates

- (void)didPost
{
    //    Gets called when the user presses the "share" button on the "ComposePost" view, this controller functions as a delegate of the former
    [self refreshDataWithNPosts:(int)self.postArray.count + 1];
}

- (void)postCell:(PostCellView *)postCell didTap:(PFUser *)user
{
    //    Posts a user connection and goes to user profile
    [self checkIfConnectionExists:user withCloseness:1];
    [self goToUserProfile:user];
}

#pragma mark - Actions

- (IBAction)composeAPost:(id)sender
{
    // display compose post view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ComposePostViewController *postViewController = [storyboard instantiateViewControllerWithIdentifier:@"composeNoNav"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:postViewController];
    [navigationController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController presentViewController:navigationController animated:YES completion:^{
        // Pass the delegate
        postViewController.delegate = self;
    }];
}

#pragma mark - Navigation

- (void)goToUserProfile:(PFUser *)user
{
    //    Goes to profile page when user taps on profile
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileViewController *profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
    // Pass the user
    profileViewController.user = user;
    [self.navigationController pushViewController:profileViewController animated:YES];
}

@end
