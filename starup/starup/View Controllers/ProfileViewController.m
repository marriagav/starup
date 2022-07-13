//
//  ProfileViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "ProfileViewController.h"

@interface ProfileViewController () <UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    Case when the profile view is accessed through the nav bar
    if (self.user == nil || self.user==PFUser.currentUser){
        self.user = PFUser.currentUser;
        //  Can only edit the profile if it is your profile
        //    Set the dropdown menu
        [self setDropDownMenu];
    }
    else {
//        When in someone elses profile page
        [self.editProfileButton removeFromSuperview];
    }
    //  Fill tableview and set outlets
    [self refreshDataWithNPosts:20];
    [self setOutlets];
    // Initialize a UIRefreshControlBottom
    [self _initializeRefreshControlB];
}

- (void)setOutlets{
    //    Set the outlets for the profile
    self.username.text = [NSString stringWithFormat:@"%@%@", @"@", self.user.username];
    self.profileName.text = [NSString stringWithFormat:@"%@ %@", self.user[@"firstname"], self.user[@"lastname"]];
    self.profileBio.text = self.user[@"userBio"];
    self.profileRole.text = self.user[@"role"];
    //  Set the profile picture
    self.profilePicture.file = self.user[@"profileImage"];
    [self.profilePicture loadInBackground];
    //    Format the profile picture
    [Algos formatPictureWithRoundedEdges:self.profilePicture];
}

- (void)setDropDownMenu{
    UIAction *editPicture = [UIAction actionWithTitle:@"Change profile picture" image:NULL identifier:NULL handler:^(UIAction* action){
        [self changeProfileImage];
    }];
    UIAction *editDetails = [UIAction actionWithTitle:@"Change my details" image:NULL identifier:NULL handler:^(UIAction* action){
        // display register view controller
        [self editProfileDetailsOnClick];
    }];
    UIMenu *menu = [[UIMenu alloc] menuByReplacingChildren:[NSArray arrayWithObjects:editPicture, editDetails, nil]];
    
    self.editProfileButton.menu = menu;
    self.editProfileButton.showsMenuAsPrimaryAction = YES;
}

- (void)editProfileDetailsOnClick{
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    EditProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"editVC"];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
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

- (void)refreshDataWithNPosts:(int) numberOfPosts{
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
    //    return amount of posts in the postArray
    
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    //    initialize cell (PostCell) to a reusable cell using the PostCell identifier
    
    //    get the post and delegate and assign it to the cell
    
    return NULL;
    
}

- (void)didPost{
    //    Gets called when the user presses the "share" button on the "ComposePost" view, this controller functions as a delegate of the former
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    Calls load more data when scrolling reaches bottom of the tableView
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    Checks if is scrolling
}

- (void)loadMoreData{
    //    Adds 20 more posts to the tableView, for infinte scrolling
    
}

//TODO: setup collection view

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
