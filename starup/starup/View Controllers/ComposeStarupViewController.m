//
//  ComposeStarupViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "ComposeStarupViewController.h"

@interface ComposeStarupViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, AddCollaboratorViewControllerDelegate>

@end

@implementation ComposeStarupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setOutlets];
    [self pictureGestureRecognizer:self.starupImage];
    // Add gesture recognizer to dissmiss keyboard when clicking on screen
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
//    Initialize Arrays
    self.ideators = [[NSMutableArray alloc] init];
    self.sharks = [[NSMutableArray alloc] init];
    self.hackers = [[NSMutableArray alloc] init];
//    Add the user as an ideator
    [self.ideators addObject:PFUser.currentUser];
}

- (void)setOutlets{
    //  Set the profile picture
    self.profilePicture.file = PFUser.currentUser[@"profileImage"];
    [self.profilePicture loadInBackground];
    //    Format the profile picture
    [Algos formatPictureWithRoundedEdges:self.profilePicture];
}

- (void)dismissKeyboard{
    //    Dissmiss the keyboard
    [self.view endEditing:YES];
}

- (void)didTapImage:(UITapGestureRecognizer *)sender{
    //    Gets called when the user taps on the image placeholder, creating and opening an UIImagePickerController
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView{
    //   TODO: If the text changes the placeholder dissapears
}

- (void)pictureGestureRecognizer:(UIImageView *)image{
    //Method to set up a tap gesture recognizer for an image
    UITapGestureRecognizer *imageTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapImage:)];
    [image addGestureRecognizer:imageTapGestureRecognizer];
    [image setUserInteractionEnabled:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Resize the image
    UIImage *resizedImage = [Algos imageWithImage:editedImage scaledToWidth: 414];
    
    self.starupImage.image = resizedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postStarup:(id)sender {
    //    Makes the call to post the image to the db
    //    Shows progress hud
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    Dissables sharebutton so that the user cant spam it
    self.shareButton.enabled = false;
    //    Makes call
    //TODO: pass the sharks, hackers and ideators to the query
    [Starup postStarup:self.starupName.text withCategory:self.starupCategory.text withDescription:self.descriptionOutlet.text withImage:self.starupImage.image withOperationSince:self.operatingSince.date withSales:(int)[self.sales.text integerValue] withGoalInvestment:(int)[self.goalInvestment.text integerValue] withPercentageToGive:(int)[self.percentageToGive.text integerValue] withSharks:self.sharks withIdeators:self.ideators withHackers:self.hackers withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error){
            NSLog(@"%@", error);
        }
        else{
            //Calls the didPost method from the delegate and dissmisses the view controller
            [self.delegate didPost];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        // hides progress hud
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Navigation

- (IBAction)goBackToStarups:(id)sender {
    // display starups view controller
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UITabBarController *nav = [storyboard instantiateViewControllerWithIdentifier:@"navBar"];
    [nav setModalPresentationStyle:UIModalPresentationFullScreen];
    [nav setSelectedViewController:[nav.viewControllers objectAtIndex:1]];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

//TODO: way to select collaborators
//TODO: set up collection views

- (IBAction)addShark:(id)sender {
    //     display edit profile view
    [self displayCollaboratorVcWithUserType:@"Shark"];
}

- (IBAction)addIdeator:(id)sender {
    //     display edit profile view
    [self displayCollaboratorVcWithUserType:@"Ideator"];
}

- (IBAction)addHacker:(id)sender {
    //     display edit profile view
    [self displayCollaboratorVcWithUserType:@"Hacker"];
}

- (void)displayCollaboratorVcWithUserType:(NSString*)userType{
    UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    AddCollaboratorViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"addCollaboratorNoNav"];
    vc.typeOfUserToAdd = userType;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Delegates

- (void)didAddIdeator:(PFUser *)user{
    [self.ideators addObject:user];
}

- (void)didAddHacker:(PFUser *)user{
    [self.ideators addObject:user];
}

- (void)didAddShark:(PFUser *)user{
    [self.ideators addObject:user];
}

@end
