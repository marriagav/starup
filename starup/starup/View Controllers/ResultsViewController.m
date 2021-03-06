//
//  ResultsViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/27/22.
//

#import "ResultsViewController.h"


@interface ResultsViewController () <UITableViewDataSource, UITableViewDelegate, ProfileCellViewDelegate>

@end


@implementation ResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  Initiallize delegate and datasource of the tableview to self
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //    Initialize the user matrix
    [self initializeMatrix];
}

- (void)initializeMatrix
{
    self.userMatrix = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *firstSection = [[NSMutableArray alloc] init];
    NSMutableArray *secondSection = [[NSMutableArray alloc] init];
    NSMutableArray *thirdSection = [[NSMutableArray alloc] init];
    //Add sectons to the matrix array
    [self.userMatrix addObject:firstSection];
    [self.userMatrix addObject:secondSection];
    [self.userMatrix addObject:thirdSection];
}


#pragma mark - TableView

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    int count = (int)self.userMatrix[section].count;
    if (count > 0){
        NSString *title = [[NSString alloc]init];
        if (section == 0) {
            title = @"Recommended";
        } else if (section == 1) {
            title = @"You may know";
        } else if (section == 2) {
            title =  @"Discover";
        }
        return title;
    }
    else{
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    //    return amount of posts in the postArray
    return self.userMatrix[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.userMatrix.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    initialize cell (profileCell) to a reusable cell using the PostCell identifier
    ProfileCellView *cell = [tableView
        dequeueReusableCellWithIdentifier:@"profileCell"];
    //    get the user and assign it to the cell
    PFUser *user = self.userMatrix[indexPath.section][indexPath.row];
    cell.user = user;
    cell.delegate = self;
    return cell;
}


#pragma mark - Search

- (void)performSearch:(NSString *)searchText
{
    //    Normalize string
    NSString *normalizedString = [[NSString alloc]
        initWithData:
            [[searchText lowercaseString] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]
            encoding:NSASCIIStringEncoding];
    // to limit network activity, reload half a second after last key press.
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchForSubstring:) object:normalizedString];
    [self performSelector:@selector(searchForSubstring:) withObject:normalizedString afterDelay:0.5];
}

- (void)searchForSubstring:(NSString *)searchText
{
    [self localCloseSearch:searchText];
    [self localDeepSearch:searchText];
    if ([self.userMatrix[0] count] < 1 || [self.userMatrix[1] count] < 1) {
        [self serverSearch:searchText];
    }
}

- (void)localCloseSearch:(NSString *)searchText
{
    //        Refresh local connections
    ConnectionsGraph *graph = [ConnectionsGraph sharedInstance];
    self.userMatrix[0] = [[graph GetCloseUsersWithSubstring:searchText withNumberOfUsers:5] mutableCopy];
    [self.tableView reloadData];
}

- (void)localDeepSearch:(NSString *)searchText
{
    //        Refresh local connections
    ConnectionsGraph *graph = [ConnectionsGraph sharedInstance];
    self.userMatrix[1] = [[graph GetDeepUsersWithSubstring:searchText withNumberOfUsers:5] mutableCopy];
    [self.tableView reloadData];
}

- (void)serverSearch:(NSString *)searchText
{
    //   Username search
    PFQuery *queryUsername = [PFUser query];
    [queryUsername whereKey:@"normalizedUsername" containsString:searchText];

    //    Full name search
    PFQuery *queryFN = [PFUser query];
    [queryFN whereKey:@"normalizedFullname" containsString:searchText];

    PFQuery *query = [PFQuery orQueryWithSubqueries:@[ queryUsername, queryFN ]];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            [self.userMatrix[2] removeAllObjects];
            for (PFUser *user in users) {
                if ((!([Algos userInArray:user withArray:self.userMatrix[0]])) && (!([Algos userInArray:user withArray:self.userMatrix[1]]))) {
                    [self.userMatrix[2] addObject:user];
                }
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation

- (void)profileCell:(ProfileCellView *)profileCell didTap:(PFUser *)user
{
    [self.delegate didTapUser:user];
}

@end
