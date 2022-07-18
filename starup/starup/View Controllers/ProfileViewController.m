//
//  ProfileViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "ProfileViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditProfileViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation ProfileViewController

#pragma mark - Initialization

// Helper variables
bool _isMoreDataLoadingP = false;
InfiniteScrollActivityView* _loadingMoreViewP;

- (void)viewDidLoad {
    [super viewDidLoad];
    //  Initiallize delegate and datasource of the tableview and collectionview to self
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //    Configuration that deppends on which users profile youre accessing
    [self prepAccordingToUser];
    //  Fill tableview, collectionview and set outlets
    [self refreshDataWithNPosts:20];
    [self refreshColletionViewData];
    [self setOutlets];
    // Initialize a UIRefreshControl
    [self _initializeRefreshControl];
    // Initialize a UIRefreshControlBottom
    self.currentMax = 20;
    [self _initializeRefreshControlB];
}

- (void)setOutlets{
    //    Set the outlets for the profile
    [self setUserTextProperties];
    //  Set the profile picture
    self.profilePicture.file = self.user[@"profileImage"];
    [self.profilePicture loadInBackground];
    //    Format the profile picture
    [Algos formatPictureWithRoundedEdges:self.profilePicture];
}

- (void)prepAccordingToUser{
    //    Case when the profile view is accessed through the nav bar
    if (self.user == nil){
        // There is only a back button if not accessed through navbar
        self.navigationItem.leftBarButtonItem = nil;
    }
    if (self.user == nil || self.user.username==PFUser.currentUser.username){
        //  Can only edit the profile if it is your profile
        self.user = PFUser.currentUser;
        //    Set the dropdown menu
        [self setDropDownMenu];
    }
    else {
        // When in someone elses profile page
        [self.editProfileButton removeFromSuperview];
    }
}

- (void)setUserTextProperties{
    self.username.text = [NSString stringWithFormat:@"%@%@", @"@", self.user.username];
    self.profileName.text = [NSString stringWithFormat:@"%@ %@", self.user[@"firstname"], self.user[@"lastname"]];
    self.profileBio.text = self.user[@"userBio"];
    self.profileRole.text = self.user[@"role"];
}

- (void)setDropDownMenu{
    UIAction *editPicture = [UIAction actionWithTitle:@"Change profile picture" image:NULL identifier:NULL handler:^(UIAction* action){
        [self changeProfileImage];
    }];
    UIAction *editDetails = [UIAction actionWithTitle:@"Change my details" image:NULL identifier:NULL handler:^(UIAction* action){
        // display register view controller
        [self editProfileDetailsOnClick];
    }];
    UIAction *logOut = [UIAction actionWithTitle:@"Log out" image:NULL identifier:NULL handler:^(UIAction* action){
        // log out user
        [self logOutUser];
    }];
    UIMenu *menu = [[UIMenu alloc] menuByReplacingChildren:[NSArray arrayWithObjects:editPicture, editDetails, logOut, nil]];
    
    self.editProfileButton.menu = menu;
    self.editProfileButton.showsMenuAsPrimaryAction = YES;
}

#pragma mark - Navigation

- (void)logOutUser{
    //    Call to log out the user
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if (error){
            NSLog(@"%@", error);
        }
        else{
            UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UIViewController *nav = [storyboard instantiateViewControllerWithIdentifier:@"loginView"];
            [nav setModalPresentationStyle:UIModalPresentationFullScreen];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }];
}

- (void)editProfileDetailsOnClick{
    //     display edit profile view
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    EditProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"editVCNoNav"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:navigationController animated:YES completion:^{
        // Pass the delegate
        vc.delegate = self;
    }];
}

- (void)changeProfileImage{
    //    Creates and opens an UIImagePickerController when the user taps the user image
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Resize the image
    UIImage *resizedImage = [Algos imageWithImage:editedImage scaledToWidth: 414];
    
    self.profilePicture.image = resizedImage;
    [self changeProfilePicture];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goBack:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegates

- (void)didEdit{
    //    Gets called when the user presses the "update" button on the "editProfile" view, this controller functions as a delegate of the former
    //    Updates the outlets for the profile
    [self setUserTextProperties];
}

#pragma mark - Network

- (void)changeProfilePicture{
    //    Call to change the profile picture in the DB
    [self.user setObject:[Algos getPFFileFromImage:self.profilePicture.image] forKey: @"profileImage"];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", error.localizedDescription);
        }
        else{
            [self refreshDataWithNPosts:20];
        }
    }];
}

- (void)refreshDataWithNPosts:(int) numberOfPosts {
    //    Refreshes the tableview data with numberOfPosts posts
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo: self.user];
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

- (void)refreshColletionViewData{
    //    Refreshes the collection view data
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Collaborator"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    [query includeKey:@"starup"];
    [query whereKey:@"user" equalTo: self.user];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *collaborators, NSError *error) {
        if (collaborators != nil) {
            self.collaboratorArray = (NSMutableArray *) collaborators;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)_beginRefresh:(UIRefreshControl *)refreshControl {
    //    Refreshes the data using the UIRefreshControl
    [self refreshColletionViewData];
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo: self.user];
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
    _loadingMoreViewP = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    _loadingMoreViewP.hidden = true;
    [self.tableView addSubview:_loadingMoreViewP];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!_isMoreDataLoadingP){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            _isMoreDataLoadingP = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            _loadingMoreViewP.frame = frame;
            [_loadingMoreViewP startAnimating];
            
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
    [_loadingMoreViewP stopAnimating];
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
    //    get the post and assign it to the cell
    Post *post = self.postArray[indexPath.row];
    cell.post=post;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    Calls load more data when scrolling reaches bottom of the tableView
    if(indexPath.row + 1 == [self.postArray count]){
        [self loadMoreData];
    }
}

#pragma mark - CollectionView

//TODO: setup collection view

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collaboratorArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    starupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"starupCollectionViewCell" forIndexPath:indexPath];
    
    //    get the collaborator and and assign it to the cell
    Collaborator *collaborator = self.collaboratorArray[indexPath.row];
    cell.collaborator = collaborator;
    return cell;
}

@end
