//
//  DetailsViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "DetailsViewController.h"

@interface DetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, profilesCollectionViewCellDelegate>

@end

@implementation DetailsViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setUpLabels];
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
    [self refreshColletionViewData];
}

- (void)_setUpLabels {
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

- (void)setProgressBar{
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 7.0f);
    self.investmentProgressBar.transform = transform;
    [self updateProgressBar];
}

- (void)updateProgressBar{
    NSNumber* currentInv = self.starup[@"currentInvestment"];
    NSNumber* goalInv = self.starup[@"goalInvestment"];
    self.progressString.text = [NSString stringWithFormat:@"%@$%@ / $%@", @"Progress: ", currentInv, goalInv];
    self.investmentProgressBar.progress = [Algos percentageWithNumbers:[currentInv floatValue] :[goalInv floatValue]];
}

#pragma mark - Network

- (void)refreshColletionViewData{
    //    Refreshes the collection view data
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Collaborator"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    [query includeKey:@"starup"];
    [query whereKey:@"starup" equalTo: self.starup];
    
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

- (void) addDependingOnUserType:(NSArray*)collaborators{
    for (Collaborator* collaborator in collaborators){
        if ([collaborator[@"typeOfUser"] isEqual: @"Ideator"]){
            [self.ideators addObject: collaborator[@"user"]];
        }
        else if ([collaborator[@"typeOfUser"] isEqual: @"Shark"]){
            [self.sharks addObject: collaborator[@"user"]];
        }
        else if ([collaborator[@"typeOfUser"] isEqual: @"Hacker"]){
            [self.hackers addObject: collaborator[@"user"]];
        }
    }
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.sharksCollectionView){
        //    get the amount of sharks
        return self.sharks.count;
    }
    else if (collectionView == self.ideatorsCollectionView){
        //    get the amount of ideators
        return self.ideators.count;
    }
    else if (collectionView == self.hackersCollectionView){
        //    get the amount of hackers
        return self.hackers.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    profilesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"profilesCollectionViewCell" forIndexPath:indexPath];
    
    if (collectionView == self.sharksCollectionView){
        //    get the shark and and assign it to the cell
        PFUser *user = self.sharks[indexPath.row];
        cell.user=user;
        cell.delegate = self;
    }
    else if (collectionView == self.ideatorsCollectionView){
        //    get the ideator and and assign it to the cell
        PFUser *user = self.ideators[indexPath.row];
        cell.user=user;
        cell.delegate = self;
    }
    else if (collectionView == self.hackersCollectionView){
        //    get the hacker and and assign it to the cell
        PFUser *user = self.hackers[indexPath.row];
        cell.user=user;
        cell.delegate = self;
    }
    return cell;
}

#pragma mark - Delegates

- (void)profileCell:(profilesCollectionViewCell *) profileCell didTap: (PFUser *)user{
    //    Goes to profile page when user taps on profile
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ProfileViewController *profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    // Pass the user
    profileViewController.user = user;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Navigation

- (IBAction)goBack:(id)sender {
    // display starups view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
