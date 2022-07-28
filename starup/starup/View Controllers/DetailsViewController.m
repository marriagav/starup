//
//  DetailsViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "DetailsViewController.h"


@interface DetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ProfilesCollectionCellViewDelegate, InvestViewControllerDelegate>

@end


@implementation DetailsViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    Initialize Arrays
    self.ideators = [[NSMutableArray alloc] init];
    self.sharks = [[NSMutableArray alloc] init];
    self.hackers = [[NSMutableArray alloc] init];
    //    Set collection views
    self.sharksCollectionView.delegate = self;
    self.sharksCollectionView.dataSource = self;
    self.ideatorsCollectionView.delegate = self;
    self.ideatorsCollectionView.dataSource = self;
    self.hackersCollectionView.delegate = self;
    self.hackersCollectionView.dataSource = self;
    [self _setUpLabels];
    [self refreshColletionViewData];
}

- (void)_setUpLabels
{
    //    Sets up the labels of the details view
    self.starupName.text = self.starup[@"starupName"];
    self.starupCategory.text = [self.starup[@"starupCategory"] capitalizedString];
    self.sales.text = [NSString stringWithFormat:@"%@%@", @"Sales ~ $", self.starup[@"sales"]];
    self.starupDescription.text = self.starup[@"starupDescription"];
    NSDate *date = self.starup[@"operatingSince"];
    self.operatingSince.text = [NSString stringWithFormat:@"%@%ld", @"Operating since: ", (long)date.year];
    self.starupImage.file = self.starup[@"starupImage"];
    [self.starupImage loadInBackground];
    [self setProgressBar];
}

- (void)setProgressBar
{
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 7.0f);
    self.investmentProgressBar.transform = transform;
    [self updateProgressBar];
}

- (void)updateProgressBar
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *currentInv = self.starup[@"currentInvestment"];
        NSNumber *goalInv = self.starup[@"goalInvestment"];
        weakSelf.progressString.text = [NSString stringWithFormat:@"%@$%@ / $%@", @"Progress: ", currentInv, goalInv];
        [weakSelf.investmentProgressBar setProgress:[Algos percentageWithNumbers:[currentInv floatValue]:[goalInv floatValue]] animated:YES];
    });
}

#pragma mark - Network

- (void)refreshColletionViewData
{
    //    Refreshes the collection view data
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Collaborator"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    [query includeKey:@"starup"];
    [query whereKey:@"starup" equalTo:self.starup];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *collaborators, NSError *error) {
        if (collaborators != nil) {
            [self addDependingOnUserType:collaborators];
            [self.sharksCollectionView reloadData];
            [self.ideatorsCollectionView reloadData];
            [self.hackersCollectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)addDependingOnUserType:(NSArray *)collaborators
{
    for (Collaborator *collaborator in collaborators) {
        if ([collaborator[@"typeOfUser"] isEqual:@"Ideator"]) {
            [self.ideators addObject:collaborator[@"user"]];
        } else if ([collaborator[@"typeOfUser"] isEqual:@"Shark"]) {
            [self.sharks addObject:collaborator[@"user"]];
        } else if ([collaborator[@"typeOfUser"] isEqual:@"Hacker"]) {
            [self.hackers addObject:collaborator[@"user"]];
        }
    }
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
                if (succeeded && closenesss == 1) {
                    // Add connection to local graph
                    ConnectionsGraph *graph = [ConnectionsGraph sharedInstance];
                    [graph addUserToGraph:user:nil];
                }
            }];
        } else {
            //    Posts a user connection
            [UserConnection postUserConnection:PFUser.currentUser withUserTwo:user withCloseness:@(closenesss) withCompletion:^(BOOL succeeded, NSError *_Nullable error) {
                if (closenesss == 1) {
                    // Add connection to local graph
                    ConnectionsGraph *graph = [ConnectionsGraph sharedInstance];
                    [graph addUserToGraph:user:nil];
                }
            }];
        }
    }];
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.sharksCollectionView) {
        //    get the amount of sharks
        return self.sharks.count;
    } else if (collectionView == self.ideatorsCollectionView) {
        //    get the amount of ideators
        return self.ideators.count;
    } else if (collectionView == self.hackersCollectionView) {
        //    get the amount of hackers
        return self.hackers.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfilesCollectionCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"profilesCollectionViewCell" forIndexPath:indexPath];

    if (collectionView == self.sharksCollectionView) {
        //    get the shark and and assign it to the cell
        PFUser *user = self.sharks[indexPath.row];
        cell.user = user;
        cell.delegate = self;
    } else if (collectionView == self.ideatorsCollectionView) {
        //    get the ideator and and assign it to the cell
        PFUser *user = self.ideators[indexPath.row];
        cell.user = user;
        cell.delegate = self;
    } else if (collectionView == self.hackersCollectionView) {
        //    get the hacker and and assign it to the cell
        PFUser *user = self.hackers[indexPath.row];
        cell.user = user;
        cell.delegate = self;
    }
    return cell;
}

#pragma mark - Delegates

- (void)profileCell:(ProfilesCollectionCellView *)profileCell didTap:(PFUser *)user
{
    //    Posts a user connection and goes to user profile
    [self checkIfConnectionExists:user withCloseness:1];
    [self goToUserProfile:user];
}

- (void)didInvest
{
    //    Update starup
    PFQuery *query = [PFQuery queryWithClassName:@"Starup"];
    [query includeKey:@"author"];
    [query whereKey:@"objectId" equalTo:self.starup.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *starups, NSError *error) {
        if (starups != nil) {
            self.starup = starups[0];
            //    Reset and refresh Arrays
            self.ideators = [[NSMutableArray alloc] init];
            self.sharks = [[NSMutableArray alloc] init];
            self.hackers = [[NSMutableArray alloc] init];
            [self refreshColletionViewData];
            //    Update ProgressBar
            [self updateProgressBar];
            //    Update/make connection
            [self checkIfConnectionExists:self.starup[@"author"] withCloseness:10];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation

- (IBAction)goToInvestments:(id)sender
{
    //    Goes to investments page
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InvestViewController *investController = [storyboard instantiateViewControllerWithIdentifier:@"investmentsVC"];
    // Pass the user
    investController.starup = self.starup;
    investController.delegate = self;
    [self.navigationController pushViewController:investController animated:YES];
}

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
