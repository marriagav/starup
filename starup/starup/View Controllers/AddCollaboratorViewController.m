//
//  AddCollaboratorViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/14/22.
//

#import "AddCollaboratorViewController.h"

@interface AddCollaboratorViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, profileCellDelegate>

@end

#pragma mark - Initialization

// Helper variables
bool _isMoreDataLoadingA = false;
InfiniteScrollActivityView* _loadingMoreViewA;

@implementation AddCollaboratorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //  Initiallize delegate and datasource of the tableview to self
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
//    Initialize the user matrix
    [self initializeMatrix];
    [self.tableView reloadData];
    [self refreshDataWithNUsers:20];
//    Initialize search bar
    [self setSearchBar];
    // Initialize a UIRefreshControlBottom
    [self _initializeRefreshControlB];
}

- (void)initializeMatrix{
    self.userMatrix = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *firstSection = [[NSMutableArray alloc] init];
    NSMutableArray *secondSection = [[NSMutableArray alloc] init];
    NSMutableArray *thirdSection = [[NSMutableArray alloc] init];
    //Add sectons to the matrix array
    [self.userMatrix addObject:firstSection];
    [self.userMatrix addObject:secondSection];
    [self.userMatrix addObject:thirdSection];
}

- (void)setSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.placeholder = @"Search by username...";
}

#pragma mark - QualityOfLife

- (void)_initializeRefreshControlB{
//    Initialices and inserts the refresh control
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    _loadingMoreViewA = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    _loadingMoreViewA.hidden = true;
    [self.tableView addSubview:_loadingMoreViewA];
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!_isMoreDataLoadingA){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            _isMoreDataLoadingA = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            _loadingMoreViewA.frame = frame;
            [_loadingMoreViewA startAnimating];
            
            // Code to load more results
            [self loadMoreData];
        }
    }
}

- (void)loadMoreData{
    //    Adds 20 more users to the tableView, for infinte scrolling
    int postsToAdd = (int)[self.userMatrix[2] count] + 20;
    [self refreshDataWithNUsers: postsToAdd];
    [_loadingMoreViewA stopAnimating];
}


#pragma mark - Network

- (void)refreshDataWithNUsers:(int) numberOfUsers {
    //    Refreshes the tableview data with numberOfUsers users
    //    Refresh the data of the first and second sections
    connectionsGraph *graph = [connectionsGraph sharedInstance];
    self.userMatrix[0] = [[graph GetCloseUsersWithSubstring:@"" withNumberOfUsers:5] mutableCopy];
    [self.tableView reloadData];
    self.userMatrix[1] = [[graph GetDeepUsersWithSubstring:@"" withNumberOfUsers:5] mutableCopy];
    [self.tableView reloadData];
    // construct query
    PFQuery *query = [PFUser query];
    query.limit = numberOfUsers;
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
            if (users != nil) {
                [self.userMatrix[2] removeAllObjects];
                for (PFUser* user in users){
                    if ((!([Algos userInArray:user withArray:self.userMatrix[0]]))&&(!([Algos userInArray:user withArray:self.userMatrix[1]]))){
                        [self.userMatrix[2] addObject:user];
                    }
                }
                [self.tableView reloadData];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
}

#pragma mark - TableView

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]init];
    if (section == 0){
        label.text = @"Connections";
    }
    else if (section == 1){
        label.text = @"You may know";
    }
    else if (section == 2){
        label.text = @"Discover";
    }
    return label;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    //    return amount of posts in the postArray
    return self.userMatrix[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.userMatrix.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    initialize cell (profileCell) to a reusable cell using the PostCell identifier
    profileCell *cell = [tableView
                      dequeueReusableCellWithIdentifier: @"profileCell"];
    //    get the user and assign it to the cell
    PFUser *user = self.userMatrix[indexPath.section][indexPath.row];
    cell.user=user;
    cell.delegate = self;
    return cell;
}

#pragma mark - SearchBar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    Search usernames in the db
//    TODO: only search after the user has stoped typing for 1 seconds
    if (searchText.length != 0) {
//        Refresh local connections
        connectionsGraph *graph = [connectionsGraph sharedInstance];
        self.userMatrix[0] = [[graph GetCloseUsersWithSubstring:searchText withNumberOfUsers:5] mutableCopy];
        [self.tableView reloadData];
        self.userMatrix[1] = [[graph GetDeepUsersWithSubstring:searchText withNumberOfUsers:5] mutableCopy];
        [self.tableView reloadData];
//        Refresh server connections
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" containsString:searchText];
        query.limit = 20;
        [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
                if (users != nil) {
                    [self.userMatrix[2] removeAllObjects];
                    for (PFUser* user in users){
                        if ((!([Algos userInArray:user withArray:self.userMatrix[0]]))&&(!([Algos userInArray:user withArray:self.userMatrix[1]]))){
                            [self.userMatrix[2] addObject:user];
                        }
                    }
                    [self.tableView reloadData];
                } else {
                    NSLog(@"%@", error.localizedDescription);
                }
        }];
    }
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)profileCell:(profileCell *) profileCell didTap: (PFUser *)user{
    [self addCollaborator: user];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCollaborator: (PFUser*)user {
    if ([self.typeOfUserToAdd isEqual:@"shark"]){
        [self.delegate didAddShark:user];
    }
    else if ([self.typeOfUserToAdd isEqual:@"ideator"]){
        [self.delegate didAddIdeator:user];
    }
    if ([self.typeOfUserToAdd isEqual:@"hacker"]){
        [self.delegate didAddHacker:user];
    }
}

@end
